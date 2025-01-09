import 'dart:developer';

import 'package:chart_q/constants/style.dart';
import 'package:chart_q/features/main/domain/models/product.dart';
import 'package:chart_q/shared/widgets/ui/app_bar.dart';
import 'package:chart_q/shared/widgets/ui/button.dart';
import 'package:chart_q/shared/widgets/ui/checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

final subscribeProvider =
    AsyncNotifierProvider<SubscribeNotifier, List<Product>>(
  () => SubscribeNotifier(),
);

class SubscribeNotifier extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() async {
    return _fetchProducts();
  }

  Future<List<Product>> _fetchProducts() async {
    // TODO: 서버로부터 구독 상품 목록 조회
    await Future.delayed(const Duration(seconds: 1));
    return [
      Product(
        id: '1',
        title: 'Basic',
        price: 2900,
        description: '광고 제거 하루에 100원!',
        isPopular: true,
      ),
      Product(
        id: '2',
        title: 'Smart',
        price: 18900,
        description: '차트게임 플레이 무한!',
      ),
      Product(
        id: '3',
        title: 'Set',
        price: 39900,
        description: '게임 플레이 무제한에 +보조지표 까지!',
      ),
    ];
  }

  Future<void> subscribe(Product product) async {
    // TODO: 구독 결제 진행
  }
}

class SubscribeScreen extends ConsumerStatefulWidget {
  const SubscribeScreen({super.key});

  @override
  ConsumerState<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends ConsumerState<SubscribeScreen> {
  Product? selectedProduct;
  bool agreed = false;

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(subscribeProvider);

    return Scaffold(
      appBar: AppBars.back(title: "구독 요금 안내", onBack: () => context.pop()),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('🌟 함께 공부하고\nMake More Money', style: AppText.h2),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: AppColor.main),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: DefaultTextStyle(
                      style: AppText.two,
                      child: Row(
                        children: [
                          Chip(
                            backgroundColor: AppColor.main,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            shape: StadiumBorder(),
                            side: BorderSide.none,
                            padding: const EdgeInsets.all(0),
                            labelPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 3),
                            label: Text('Monthly',
                                style: TextStyle(color: AppColor.white)),
                          ),
                          Chip(
                            backgroundColor: AppColor.white,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            shape: StadiumBorder(),
                            side: BorderSide.none,
                            padding: const EdgeInsets.all(0),
                            labelPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 3),
                            label: Text('Annual',
                                style: TextStyle(color: AppColor.main)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            products.when(
              data: (products) {
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductView(
                      product: product,
                      isSelected: product.id == selectedProduct?.id,
                      onTap: () {
                        setState(() {
                          selectedProduct = product;
                        });
                      },
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemCount: products.length,
                );
              },
              error: (error, stackTrace) =>
                  Center(child: Text('Error: $error')),
              loading: () => Center(child: const Text('Loading...')),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppCheckbox(onChanged: (value) {
                  setState(() {
                    agreed = value ?? false;
                  });
                }),
                const SizedBox(width: 8),
                Text('유의사항을 모두 확인했습니다',
                    style: AppText.three.copyWith(color: AppColor.gray))
              ],
            ),
            const SizedBox(height: 16),
            AppButtons.primary(
              title: '결제하기',
              onPressed: () async {
                // TODO: 구독 결제 진행
                await ref
                    .read(subscribeProvider.notifier)
                    .subscribe(selectedProduct!);
              },
              disabled: selectedProduct == null || !agreed,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: AppColor.gray, width: 0.5)),
                  ),
                  child: GestureDetector(
                    onTap: () {},
                    child: Text(
                      '이용약관',
                      style: AppText.three
                          .copyWith(color: AppColor.gray, height: 1.2),
                    ),
                  ),
                ),
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: ColoredBox(
                        color: AppColor.lineGray,
                        child: SizedBox(width: 1, height: 12))),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: AppColor.gray, width: 0.5)),
                  ),
                  child: GestureDetector(
                    onTap: () {},
                    child: Text(
                      '개인정보 보호정책',
                      style: AppText.three
                          .copyWith(color: AppColor.gray, height: 1.2),
                    ),
                  ),
                ),
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: ColoredBox(
                        color: AppColor.lineGray,
                        child: SizedBox(width: 1, height: 12))),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: AppColor.gray, width: 0.5)),
                  ),
                  child: GestureDetector(
                    onTap: () {},
                    child: Text(
                      '구매취소',
                      style: AppText.three
                          .copyWith(color: AppColor.gray, height: 1.2),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}

class ProductView extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final bool isSelected;
  const ProductView({
    super.key,
    required this.product,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final button = GestureDetector(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
                color: isSelected ? AppColor.main : AppColor.lineGray),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DefaultTextStyle(
                style: AppText.h3.copyWith(
                    color: isSelected ? AppColor.main : AppColor.gray),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(product.title),
                    Text(NumberFormat('#,###').format(product.price)),
                  ],
                ),
              ),
              Text(
                product.description ?? '',
                style: AppText.three.copyWith(
                    color: isSelected ? AppColor.main : AppColor.gray),
              ),
            ],
          )),
    );
    if (product.isPopular == true) {
      return Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            button,
            Positioned(
              top: -16,
              left: 16,
              child: ColoredBox(
                color: AppColor.white,
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? AppColor.main : AppColor.white,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                        color: isSelected ? AppColor.main : AppColor.lineGray),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                  child: Text('인기',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          height: 5 / 3,
                          color: isSelected ? AppColor.white : AppColor.gray)),
                ),
              ),
            )
          ],
        ),
      );
    }
    return button;
  }
}
