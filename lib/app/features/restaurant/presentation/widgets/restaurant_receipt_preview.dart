import 'package:flutter/material.dart';
import '../../data/models/restaurant_entity.dart';

class RestaurantReceiptPreview extends StatelessWidget {
  final RestaurantEntity restaurant;

  const RestaurantReceiptPreview({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 360),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top receipt paper jagged edge decoration
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.receipt_outlined, size: 14, color: Colors.grey.shade700),
                      const SizedBox(width: 4),
                      Text(
                        isArabic ? 'معاينة الفاتورة الضريبية' : 'Tax Invoice Preview',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Restaurant Logo / Emblem
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.restaurant,
                    color: theme.colorScheme.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 10),

                // Restaurant Names
                Text(
                  restaurant.nameAr.isNotEmpty ? restaurant.nameAr : 'اسم المطعم بالعربية',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (restaurant.nameEn.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    restaurant.nameEn,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],

                if (restaurant.slogan.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    '« ${restaurant.slogan} »',
                    style: TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],

                const SizedBox(height: 12),
                const _ReceiptDivider(),
                const SizedBox(height: 10),

                // Header Note
                if (restaurant.receiptHeaderNote.isNotEmpty) ...[
                  Text(
                    restaurant.receiptHeaderNote,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                ],

                // Tax & CR Information Table
                _buildReceiptRow(
                  isArabic ? 'الرقم الضريبي (VAT):' : 'VAT No:',
                  restaurant.taxNumber.isNotEmpty ? restaurant.taxNumber : '300000000000003',
                  isBold: true,
                ),
                _buildReceiptRow(
                  isArabic ? 'السجل التجاري (CR):' : 'CR No:',
                  restaurant.commercialRegistration.isNotEmpty
                      ? restaurant.commercialRegistration
                      : '1010000000',
                ),
                _buildReceiptRow(
                  isArabic ? 'الهاتف / الجوال:' : 'Phone:',
                  restaurant.mobileNumber.isNotEmpty
                      ? restaurant.mobileNumber
                      : restaurant.phoneNumber,
                ),
                if (restaurant.district.isNotEmpty || restaurant.city.isNotEmpty)
                  _buildReceiptRow(
                    isArabic ? 'الموقع:' : 'Location:',
                    '${restaurant.city} - ${restaurant.district}',
                  ),

                const SizedBox(height: 10),
                const _ReceiptDivider(),
                const SizedBox(height: 10),

                // Sample Order Items Table
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isArabic ? 'الصنف' : 'Item',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    Text(
                      isArabic ? 'الكمية' : 'Qty',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    Text(
                      isArabic ? 'المجموع' : 'Total',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                _buildOrderItem(isArabic ? 'وجبة مشاوي مشكلة' : 'Mixed Grill Plate', '1', '65.00 ${restaurant.currency}'),
                _buildOrderItem(isArabic ? 'حمص ومقبلات بكرة' : 'Bokrah Appetizers', '2', '28.00 ${restaurant.currency}'),
                _buildOrderItem(isArabic ? 'عصير برتقال طازج' : 'Fresh Orange Juice', '2', '24.00 ${restaurant.currency}'),

                const SizedBox(height: 10),
                const _ReceiptDivider(),
                const SizedBox(height: 8),

                // Totals
                _buildSummaryRow(isArabic ? 'المجموع الفرعي:' : 'Subtotal:', '117.00 ${restaurant.currency}'),
                if (restaurant.isTaxEnabled)
                  _buildSummaryRow(
                    '${isArabic ? 'ضريبة القيمة المضافة' : 'VAT'} (${restaurant.taxRate}%):',
                    '${(117.00 * (restaurant.taxRate / 100)).toStringAsFixed(2)} ${restaurant.currency}',
                  ),
                if (restaurant.serviceChargeRate > 0)
                  _buildSummaryRow(
                    '${isArabic ? 'رسوم الخدمة' : 'Service Charge'} (${restaurant.serviceChargeRate}%):',
                    '${(117.00 * (restaurant.serviceChargeRate / 100)).toStringAsFixed(2)} ${restaurant.currency}',
                  ),
                const SizedBox(height: 4),
                _buildSummaryRow(
                  isArabic ? 'الإجمالي الكلي:' : 'Grand Total:',
                  '${(117.00 * (1 + (restaurant.isTaxEnabled ? restaurant.taxRate / 100 : 0) + restaurant.serviceChargeRate / 100)).toStringAsFixed(2)} ${restaurant.currency}',
                  isTotal: true,
                ),

                const SizedBox(height: 14),
                const _ReceiptDivider(),
                const SizedBox(height: 12),

                // Simulated ZATCA / QR Code
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.qr_code_2, size: 54, color: Colors.grey.shade800),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isArabic ? 'رمز الاستجابة السريعة' : 'QR Code (ZATCA)',
                              style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              isArabic ? 'متوافق مع الفوترة الإلكترونية' : 'E-Invoicing Compliant',
                              style: TextStyle(fontSize: 9.5, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Footer Note
                if (restaurant.receiptFooterNote.isNotEmpty) ...[
                  Text(
                    restaurant.receiptFooterNote,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                ],

                // Operating Hours
                Text(
                  isArabic
                      ? 'ساعات العمل: ${restaurant.openingTime} - ${restaurant.closingTime}'
                      : 'Hours: ${restaurant.openingTime} - ${restaurant.closingTime}',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Bottom receipt paper teeth decoration
          CustomPaint(
            size: const Size(double.infinity, 8),
            painter: _ReceiptTeethPainter(),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              color: Colors.grey.shade700,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(String name, String qty, String total) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 11, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 30,
            child: Text(
              qty,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
            ),
          ),
          Text(
            total,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 13 : 11,
              fontWeight: isTotal ? FontWeight.w900 : FontWeight.w500,
              color: isTotal ? Colors.black87 : Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 14 : 11,
              fontWeight: isTotal ? FontWeight.w900 : FontWeight.w600,
              color: isTotal ? const Color(0xFF2E7D64) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptDivider extends StatelessWidget {
  const _ReceiptDivider();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 4.0;
        const dashHeight = 1.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return const SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color(0xFFCCCCCC)),
              ),
            );
          }),
        );
      },
    );
  }
}

class _ReceiptTeethPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.fill;

    final path = Path();
    const toothWidth = 10.0;
    const toothHeight = 6.0;
    final teethCount = (size.width / toothWidth).ceil();

    path.moveTo(0, 0);
    for (int i = 0; i < teethCount; i++) {
      path.lineTo((i * toothWidth) + (toothWidth / 2), toothHeight);
      path.lineTo((i + 1) * toothWidth, 0);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
