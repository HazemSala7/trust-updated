import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductCardPhoneNumber extends StatelessWidget {
  final String productName;
  final String resultMessageWarrantStatus;
  final String maintenceStatus;
  final String maintenceNotes;
  final String maintenceDesc;
  final String customerName;
  final String customerPhone;

  const ProductCardPhoneNumber({
    required this.productName,
    required this.resultMessageWarrantStatus,
    required this.maintenceStatus,
    required this.maintenceNotes,
    required this.maintenceDesc,
    required this.customerName,
    required this.customerPhone,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(12.0), // Smaller margin
      padding: const EdgeInsets.all(12.0), // Smaller padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0), // Reduced corner radius
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1), // Subtle shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildColumn(
            title: AppLocalizations.of(context)!.product_name,
            value: productName,
          ),
          _buildDivider(),
          _buildColumn(
            title: AppLocalizations.of(context)!.warranty_inspection,
            value: resultMessageWarrantStatus,
          ),
          _buildDivider(),
          _buildColumn(
            title: AppLocalizations.of(context)!.maintenance_status,
            value: maintenceStatus,
          ),
          _buildDivider(),
          _buildColumn(
            title: AppLocalizations.of(context)!.maintenance_notes,
            value: maintenceNotes,
          ),
          _buildDivider(),
          _buildColumn(
            title: AppLocalizations.of(context)!.malfunction_description,
            value: maintenceDesc,
          ),
          _buildDivider(),
          _buildColumn(
            title: AppLocalizations.of(context)!.customer_name,
            value: customerName,
          ),
          _buildDivider(),
          _buildColumn(
            title: AppLocalizations.of(context)!.customer_phone,
            value: customerPhone,
          ),
        ],
      ),
    );
  }

  Widget _buildColumn({required String title, required String value}) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 4.0), // Smaller vertical spacing
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14, // Smaller font size for titles
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 2), // Reduced spacing between title and value
          Text(
            value,
            style: const TextStyle(
              fontSize: 12, // Smaller font size for values
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Color.fromARGB(255, 228, 228, 228),
      thickness: 0.5, // Thinner divider
      height: 8.0, // Reduced height for divider spacing
    );
  }
}
