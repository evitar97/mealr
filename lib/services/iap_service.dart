import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

enum MealfulProPlan {
  monthly('mealful_pro_monthly'),
  yearly('mealful_pro_yearly');

  const MealfulProPlan(this.productId);

  final String productId;
}

class IapService extends ChangeNotifier {
  IapService({InAppPurchase? inAppPurchase})
    : _inAppPurchase = inAppPurchase ?? InAppPurchase.instance;

  static const Set<String> productIds = {
    'mealful_pro_monthly',
    'mealful_pro_yearly',
  };

  final InAppPurchase _inAppPurchase;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;
  void Function(String productId)? _onProUnlocked;

  bool available = false;
  bool loading = true;
  bool purchasePending = false;
  String? errorMessage;

  final Map<String, ProductDetails> _products = {};

  ProductDetails? product(MealfulProPlan plan) => _products[plan.productId];

  String priceFor(MealfulProPlan plan, String fallback) {
    return product(plan)?.price ?? fallback;
  }

  bool get canPurchase => available && _products.isNotEmpty && !purchasePending;

  Future<void> initialize({
    required void Function(String productId) onProUnlocked,
  }) async {
    _onProUnlocked = onProUnlocked;
    _purchaseSubscription ??= _inAppPurchase.purchaseStream.listen(
      _handlePurchaseUpdates,
      onDone: () {
        _purchaseSubscription?.cancel();
        _purchaseSubscription = null;
      },
      onError: (Object error) {
        errorMessage = error.toString();
        purchasePending = false;
        notifyListeners();
      },
    );
    await refreshProducts();
  }

  Future<void> refreshProducts() async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    available = await _inAppPurchase.isAvailable();
    if (!available) {
      loading = false;
      errorMessage = 'Store unavailable';
      notifyListeners();
      return;
    }

    final response = await _inAppPurchase.queryProductDetails(productIds);
    _products
      ..clear()
      ..addEntries(
        response.productDetails.map((product) => MapEntry(product.id, product)),
      );

    if (response.error != null) {
      errorMessage = response.error!.message;
    } else if (response.notFoundIDs.isNotEmpty) {
      errorMessage = 'Missing products: ${response.notFoundIDs.join(', ')}';
    }

    loading = false;
    notifyListeners();
  }

  Future<void> buy(MealfulProPlan plan) async {
    final details = product(plan);
    if (!available || details == null || purchasePending) {
      errorMessage = 'Product unavailable';
      notifyListeners();
      return;
    }

    purchasePending = true;
    errorMessage = null;
    notifyListeners();

    final purchaseParam = PurchaseParam(productDetails: details);
    final started = await _inAppPurchase.buyNonConsumable(
      purchaseParam: purchaseParam,
    );
    if (!started) {
      purchasePending = false;
      errorMessage = 'Purchase could not start';
      notifyListeners();
    }
  }

  Future<void> restorePurchases() async {
    if (!available) {
      await refreshProducts();
    }
    if (!available) return;

    purchasePending = true;
    errorMessage = null;
    notifyListeners();
    await _inAppPurchase.restorePurchases();
  }

  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (!productIds.contains(purchase.productID)) continue;

      switch (purchase.status) {
        case PurchaseStatus.pending:
          purchasePending = true;
        case PurchaseStatus.error:
          purchasePending = false;
          errorMessage = purchase.error?.message ?? 'Purchase failed';
        case PurchaseStatus.canceled:
          purchasePending = false;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          purchasePending = false;
          errorMessage = null;
          _onProUnlocked?.call(purchase.productID);
      }

      if (purchase.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchase);
      }
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _purchaseSubscription?.cancel();
    super.dispose();
  }
}
