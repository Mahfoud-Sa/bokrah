import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bokrah_design_system/bokrah_design_system.dart';
import '../../data/models/restaurant_entity.dart';
import '../../data/services/restaurant_service.dart';
import '../cubits/restaurant_cubit.dart';
import '../cubits/restaurant_state.dart';
import '../widgets/restaurant_receipt_preview.dart';
import '../../../users/presentation/cubits/session_cubit.dart';

class RestaurantInfoPage extends StatefulWidget {
  const RestaurantInfoPage({super.key});

  @override
  State<RestaurantInfoPage> createState() => _RestaurantInfoPageState();
}

class _RestaurantInfoPageState extends State<RestaurantInfoPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  late TextEditingController _nameArController;
  late TextEditingController _nameEnController;
  late TextEditingController _sloganController;
  late TextEditingController _cuisineTypeController;

  late TextEditingController _crController;
  late TextEditingController _taxNumberController;
  late TextEditingController _taxRateController;
  late TextEditingController _currencyController;

  late TextEditingController _phoneController;
  late TextEditingController _mobileController;
  late TextEditingController _emailController;
  late TextEditingController _websiteController;

  late TextEditingController _countryController;
  late TextEditingController _cityController;
  late TextEditingController _districtController;
  late TextEditingController _streetController;
  late TextEditingController _buildingController;
  late TextEditingController _postalCodeController;
  late TextEditingController _shortAddressController;

  late TextEditingController _headerNoteController;
  late TextEditingController _footerNoteController;
  late TextEditingController _serviceChargeController;
  late TextEditingController _openingTimeController;
  late TextEditingController _closingTimeController;

  bool _isTaxEnabled = true;
  String _selectedCurrency = 'SAR';
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initControllers();
  }

  void _initControllers() {
    _nameArController = TextEditingController();
    _nameEnController = TextEditingController();
    _sloganController = TextEditingController();
    _cuisineTypeController = TextEditingController();

    _crController = TextEditingController();
    _taxNumberController = TextEditingController();
    _taxRateController = TextEditingController();
    _currencyController = TextEditingController(text: 'SAR');

    _phoneController = TextEditingController();
    _mobileController = TextEditingController();
    _emailController = TextEditingController();
    _websiteController = TextEditingController();

    _countryController = TextEditingController();
    _cityController = TextEditingController();
    _districtController = TextEditingController();
    _streetController = TextEditingController();
    _buildingController = TextEditingController();
    _postalCodeController = TextEditingController();
    _shortAddressController = TextEditingController();

    _headerNoteController = TextEditingController();
    _footerNoteController = TextEditingController();
    _serviceChargeController = TextEditingController();
    _openingTimeController = TextEditingController();
    _closingTimeController = TextEditingController();
  }

  void _populateForm(RestaurantEntity r) {
    if (_isInitialized) return;
    _nameArController.text = r.nameAr;
    _nameEnController.text = r.nameEn;
    _sloganController.text = r.slogan;
    _cuisineTypeController.text = r.cuisineType;

    _crController.text = r.commercialRegistration;
    _taxNumberController.text = r.taxNumber;
    _taxRateController.text = r.taxRate.toString();
    _currencyController.text = r.currency;
    _selectedCurrency = r.currency;
    _isTaxEnabled = r.isTaxEnabled;

    _phoneController.text = r.phoneNumber;
    _mobileController.text = r.mobileNumber;
    _emailController.text = r.email;
    _websiteController.text = r.website;

    _countryController.text = r.country;
    _cityController.text = r.city;
    _districtController.text = r.district;
    _streetController.text = r.street;
    _buildingController.text = r.buildingNumber;
    _postalCodeController.text = r.postalCode;
    _shortAddressController.text = r.shortAddress;

    _headerNoteController.text = r.receiptHeaderNote;
    _footerNoteController.text = r.receiptFooterNote;
    _serviceChargeController.text = r.serviceChargeRate.toString();
    _openingTimeController.text = r.openingTime;
    _closingTimeController.text = r.closingTime;

    _isInitialized = true;
  }

  RestaurantEntity _buildCurrentEntity(RestaurantEntity original) {
    return original.copyWith(
      nameAr: _nameArController.text.trim(),
      nameEn: _nameEnController.text.trim(),
      slogan: _sloganController.text.trim(),
      cuisineType: _cuisineTypeController.text.trim(),
      commercialRegistration: _crController.text.trim(),
      taxNumber: _taxNumberController.text.trim(),
      taxRate: double.tryParse(_taxRateController.text) ?? 15.0,
      isTaxEnabled: _isTaxEnabled,
      currency: _selectedCurrency,
      phoneNumber: _phoneController.text.trim(),
      mobileNumber: _mobileController.text.trim(),
      email: _emailController.text.trim(),
      website: _websiteController.text.trim(),
      country: _countryController.text.trim(),
      city: _cityController.text.trim(),
      district: _districtController.text.trim(),
      street: _streetController.text.trim(),
      buildingNumber: _buildingController.text.trim(),
      postalCode: _postalCodeController.text.trim(),
      shortAddress: _shortAddressController.text.trim(),
      receiptHeaderNote: _headerNoteController.text.trim(),
      receiptFooterNote: _footerNoteController.text.trim(),
      serviceChargeRate:
          double.tryParse(_serviceChargeController.text) ?? 0.0,
      openingTime: _openingTimeController.text.trim(),
      closingTime: _closingTimeController.text.trim(),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameArController.dispose();
    _nameEnController.dispose();
    _sloganController.dispose();
    _cuisineTypeController.dispose();
    _crController.dispose();
    _taxNumberController.dispose();
    _taxRateController.dispose();
    _currencyController.dispose();
    _phoneController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _streetController.dispose();
    _buildingController.dispose();
    _postalCodeController.dispose();
    _shortAddressController.dispose();
    _headerNoteController.dispose();
    _footerNoteController.dispose();
    _serviceChargeController.dispose();
    _openingTimeController.dispose();
    _closingTimeController.dispose();
    super.dispose();
  }

  Future<void> _handleSave(
      BuildContext context, RestaurantEntity current) async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يُرجى التأكد من ملء جميع الحقول المطلوبة بشكل صحيح'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final cubit = context.read<RestaurantCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final entityToSave = _buildCurrentEntity(current);
    final success = await cubit.updateRestaurant(entityToSave);
    if (!mounted) return;
    if (success) {
      messenger.showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('تم حفظ وتحديث بيانات المطعم بنجاح!'),
            ],
          ),
          backgroundColor: Color(0xFF2E7D64),
        ),
      );
    }
  }

  Future<void> _confirmReset(BuildContext context) async {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final cubit = context.read<RestaurantCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: AlertDialog(
          title: Text(isArabic ? 'استعادة الافتراضي' : 'Reset to Defaults'),
          content: Text(
            isArabic
                ? 'هل أنت متأكد من رغبتك في استعادة بيانات المطعم الافتراضية؟ سيتم استبدال البيانات الحالية.'
                : 'Are you sure you want to restore the default restaurant profile? Current changes will be overwritten.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx, false),
              child: Text(isArabic ? 'إلغاء' : 'Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () => Navigator.pop(dialogCtx, true),
              child: Text(isArabic ? 'استعادة' : 'Reset'),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true && mounted) {
      _isInitialized = false;
      await cubit.resetDefaults();
      final state = cubit.state;
      if (state is RestaurantLoaded && mounted) {
        setState(() {
          _populateForm(state.restaurant);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RestaurantCubit(
        service: RestaurantService(),
      )..loadRestaurant(),
      child: BlocConsumer<RestaurantCubit, RestaurantState>(
        listener: (context, state) {
          if (state is RestaurantLoaded && !_isInitialized) {
            _populateForm(state.restaurant);
          }
        },
        builder: (context, state) {
          final isArabic = Localizations.localeOf(context).languageCode == 'ar';
          final screenWidth = MediaQuery.of(context).size.width;
          final isWide = screenWidth >= 1000;

          // Permission check
          bool isAdmin = true;
          try {
            isAdmin = context.watch<SessionCubit>().state.isAdmin;
          } catch (_) {}

          if (state is RestaurantLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final restaurant = state is RestaurantLoaded
              ? state.restaurant
              : RestaurantEntity.defaultRestaurant();

          if (!_isInitialized) {
            _populateForm(restaurant);
          }

          final liveEntity = _buildCurrentEntity(restaurant);

          return Directionality(
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  isArabic ? 'بيانات وإعدادات المطعم' : 'Restaurant Profile',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                backgroundColor: const Color(0xFF2E7D64),
                foregroundColor: Colors.white,
                actions: [
                  if (isAdmin)
                    TextButton.icon(
                      icon: const Icon(Icons.restore, color: Colors.white70, size: 18),
                      label: Text(
                        isArabic ? 'الافتراضي' : 'Default',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      onPressed: () => _confirmReset(context),
                    ),
                  const SizedBox(width: 8),
                ],
              ),
              body: Form(
                key: _formKey,
                onChanged: () {
                  // Trigger state update to refresh live receipt preview
                  setState(() {});
                },
                child: isWide
                    ? _buildWideLayout(context, restaurant, liveEntity, isAdmin, isArabic)
                    : _buildMobileLayout(context, restaurant, liveEntity, isAdmin, isArabic),
              ),
            ),
          );
        },
      ),
    );
  }

  // Two-column layout for desktop / tablet
  Widget _buildWideLayout(
    BuildContext context,
    RestaurantEntity original,
    RestaurantEntity liveEntity,
    bool isAdmin,
    bool isArabic,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: Form & Tabs
        Expanded(
          flex: 6,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroBanner(liveEntity, isAdmin, isArabic),
                const SizedBox(height: 20),
                _buildTabBar(isArabic),
                const SizedBox(height: 16),
                _buildTabContent(isAdmin, isArabic),
                const SizedBox(height: 24),
                if (isAdmin) _buildActionFooter(context, original, isArabic),
              ],
            ),
          ),
        ),

        // Vertical divider
        VerticalDivider(
          width: 1,
          thickness: 1,
          color: Theme.of(context).dividerColor.withValues(alpha: 0.15),
        ),

        // Right Column: Live Receipt & Card Preview
        Expanded(
          flex: 4,
          child: Container(
            color: Theme.of(context).colorScheme.surfaceContainerLowest,
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.visibility_outlined, size: 18, color: Color(0xFF2E7D64)),
                      const SizedBox(width: 6),
                      Text(
                        isArabic ? 'المعاينة الفورية للفاتورة' : 'Live Receipt Preview',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D64),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isArabic
                        ? 'تحديث تلقائي لمظهر الفاتورة والبيانات المطبوعة للزبائن'
                        : 'Real-time preview of customer receipts and invoice headers',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  RestaurantReceiptPreview(restaurant: liveEntity),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Single-column layout with preview sheet for mobile
  Widget _buildMobileLayout(
    BuildContext context,
    RestaurantEntity original,
    RestaurantEntity liveEntity,
    bool isAdmin,
    bool isArabic,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroBanner(liveEntity, isAdmin, isArabic),
          const SizedBox(height: 16),
          // Preview button for mobile
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 44),
              foregroundColor: const Color(0xFF2E7D64),
              side: const BorderSide(color: Color(0xFF2E7D64)),
            ),
            icon: const Icon(Icons.receipt_long),
            label: Text(isArabic ? 'معاينة شكل الفاتورة المطبوعة' : 'View Receipt Preview'),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (ctx) => Directionality(
                  textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 16),
                          RestaurantReceiptPreview(restaurant: liveEntity),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildTabBar(isArabic),
          const SizedBox(height: 16),
          _buildTabContent(isAdmin, isArabic),
          const SizedBox(height: 24),
          if (isAdmin) _buildActionFooter(context, original, isArabic),
        ],
      ),
    );
  }

  // Top Hero banner card
  Widget _buildHeroBanner(
    RestaurantEntity r,
    bool isAdmin,
    bool isArabic,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2E7D64),
            const Color(0xFF1E5242),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D64).withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.restaurant_menu,
                  size: 34,
                  color: Color(0xFF2E7D64),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            r.nameAr.isNotEmpty ? r.nameAr : 'مطعم بكرة',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.verified, size: 12, color: Colors.amberAccent),
                              const SizedBox(width: 3),
                              Text(
                                isArabic ? 'منشأة معتمدة' : 'Verified',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      r.nameEn.isNotEmpty ? r.nameEn : 'Bokrah Restaurant',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${r.city} • ${r.cuisineType} • ${r.currency}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (!isAdmin) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.amber.shade700.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amberAccent.withValues(alpha: 0.5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lock_outline, size: 16, color: Colors.white),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      isArabic
                          ? 'تنبيه: أنت تتصفح بصفة مستخدم عادي (للعرض فقط). التعديل متاح للمدير العام فقط.'
                          : 'Notice: You are in view-only mode. Only the admin can modify restaurant information.',
                      style: const TextStyle(fontSize: 11.5, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Navigation tab bar
  Widget _buildTabBar(bool isArabic) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: const Color(0xFF2E7D64),
        unselectedLabelColor: Colors.grey,
        indicatorColor: const Color(0xFF2E7D64),
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: [
          Tab(
            icon: const Icon(Icons.storefront_outlined, size: 20),
            text: isArabic ? 'الهوية والبيانات' : 'Identity',
          ),
          Tab(
            icon: const Icon(Icons.gavel_outlined, size: 20),
            text: isArabic ? 'الضرائب والسجل' : 'Legal & Tax',
          ),
          Tab(
            icon: const Icon(Icons.contact_mail_outlined, size: 20),
            text: isArabic ? 'الاتصال والعنوان' : 'Contact & Address',
          ),
          Tab(
            icon: const Icon(Icons.receipt_outlined, size: 20),
            text: isArabic ? 'الفاتورة والتشغيل' : 'Receipt & Operations',
          ),
        ],
      ),
    );
  }

  // Tab content container
  Widget _buildTabContent(bool isAdmin, bool isArabic) {
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, _) {
        return switch (_tabController.index) {
          0 => _buildIdentityTab(isAdmin, isArabic),
          1 => _buildLegalTaxTab(isAdmin, isArabic),
          2 => _buildContactAddressTab(isAdmin, isArabic),
          3 => _buildReceiptOperationsTab(isAdmin, isArabic),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }

  // 1. Identity Tab
  Widget _buildIdentityTab(bool isAdmin, bool isArabic) {
    return BkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            isArabic ? 'بيانات المطعم الأساسية' : 'Basic Restaurant Details',
            Icons.store,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _nameArController,
            label: isArabic ? 'اسم المطعم (بالعربية) *' : 'Restaurant Name (Arabic) *',
            icon: Icons.title,
            enabled: isAdmin,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'هذا الحقل مطلوب' : null,
          ),
          const SizedBox(height: 14),
          _buildTextField(
            controller: _nameEnController,
            label: isArabic ? 'اسم المطعم (بالإنجليزية) *' : 'Restaurant Name (English) *',
            icon: Icons.language,
            enabled: isAdmin,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'هذا الحقل مطلوب' : null,
          ),
          const SizedBox(height: 14),
          _buildTextField(
            controller: _sloganController,
            label: isArabic ? 'الشعار اللفظي (Slogan)' : 'Tagline / Slogan',
            icon: Icons.format_quote,
            enabled: isAdmin,
          ),
          const SizedBox(height: 14),
          _buildTextField(
            controller: _cuisineTypeController,
            label: isArabic ? 'تصنيف المأكولات / نوع المطبخ' : 'Cuisine Type',
            icon: Icons.restaurant,
            enabled: isAdmin,
          ),
        ],
      ),
    );
  }

  // 2. Legal & Tax Tab
  Widget _buildLegalTaxTab(bool isAdmin, bool isArabic) {
    return BkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            isArabic ? 'البيانات الضريبية والسجل التجاري' : 'Legal & VAT Information',
            Icons.gavel,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _taxNumberController,
            label: isArabic ? 'الرقم الضريبي للمنشأة (15 رقماً) *' : 'VAT Registration Number *',
            icon: Icons.badge_outlined,
            enabled: isAdmin,
            keyboardType: TextInputType.number,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'هذا الحقل مطلوب';
              if (v.trim().length != 15 && v.trim().length != 10) {
                return 'الرقم الضريبي المعتمد يتكون عادة من 15 رقماً';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          _buildTextField(
            controller: _crController,
            label: isArabic ? 'رقم السجل التجاري (CR Number) *' : 'Commercial Registration No *',
            icon: Icons.confirmation_number_outlined,
            enabled: isAdmin,
            keyboardType: TextInputType.number,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'هذا الحقل مطلوب' : null,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _taxRateController,
                  label: isArabic ? 'نسبة الضريبة الافتراضية (%)' : 'VAT Rate (%)',
                  icon: Icons.percent,
                  enabled: isAdmin,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedCurrency,
                  decoration: InputDecoration(
                    labelText: isArabic ? 'العملة الأساسية' : 'Currency',
                    prefixIcon: const Icon(Icons.monetization_on_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'SAR', child: Text('SAR (ر.س)')),
                    DropdownMenuItem(value: 'USD', child: Text('USD (\$)')),
                    DropdownMenuItem(value: 'AED', child: Text('AED (د.إ)')),
                    DropdownMenuItem(value: 'KWD', child: Text('KWD (د.ك)')),
                    DropdownMenuItem(value: 'BHD', child: Text('BHD (د.ب)')),
                    DropdownMenuItem(value: 'OMR', child: Text('OMR (ر.ع)')),
                    DropdownMenuItem(value: 'JOD', child: Text('JOD (د.أ)')),
                    DropdownMenuItem(value: 'EGP', child: Text('EGP (ج.م)')),
                  ],
                  onChanged: isAdmin
                      ? (val) {
                          if (val != null) {
                            setState(() => _selectedCurrency = val);
                          }
                        }
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: Text(
              isArabic ? 'تفعيل احتساب الضريبة في الفواتير' : 'Enable VAT in Invoices',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              isArabic
                  ? 'عند التعطيل لن يتم إدراج سطر الضريبة في الحسابات والفواتير'
                  : 'Disable to issue tax-exempt bills',
            ),
            value: _isTaxEnabled,
            activeThumbColor: const Color(0xFF2E7D64),
            onChanged: isAdmin
                ? (val) {
                    setState(() => _isTaxEnabled = val);
                  }
                : null,
          ),
        ],
      ),
    );
  }

  // 3. Contact & Address Tab
  Widget _buildContactAddressTab(bool isAdmin, bool isArabic) {
    return BkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            isArabic ? 'بيانات الاتصال والعنوان الوطني' : 'Contact & Address Information',
            Icons.location_on_outlined,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _phoneController,
                  label: isArabic ? 'الهاتف الثابت / الموحد' : 'Landline / Unified Phone',
                  icon: Icons.phone,
                  enabled: isAdmin,
                  keyboardType: TextInputType.phone,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildTextField(
                  controller: _mobileController,
                  label: isArabic ? 'الجوال / الواتساب' : 'Mobile / WhatsApp',
                  icon: Icons.phone_android,
                  enabled: isAdmin,
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _emailController,
                  label: isArabic ? 'البريد الإلكتروني' : 'Email Address',
                  icon: Icons.email_outlined,
                  enabled: isAdmin,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildTextField(
                  controller: _websiteController,
                  label: isArabic ? 'الموقع الإلكتروني' : 'Website',
                  icon: Icons.web_outlined,
                  enabled: isAdmin,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(),
          const SizedBox(height: 12),
          Text(
            isArabic ? 'العنوان الجغرافي والوطني' : 'Physical & National Address',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _countryController,
                  label: isArabic ? 'الدولة' : 'Country',
                  icon: Icons.flag_outlined,
                  enabled: isAdmin,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildTextField(
                  controller: _cityController,
                  label: isArabic ? 'المدينة' : 'City',
                  icon: Icons.location_city,
                  enabled: isAdmin,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _districtController,
                  label: isArabic ? 'الحي' : 'District',
                  icon: Icons.map_outlined,
                  enabled: isAdmin,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildTextField(
                  controller: _streetController,
                  label: isArabic ? 'الشارع' : 'Street',
                  icon: Icons.edit_road_outlined,
                  enabled: isAdmin,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _buildingController,
                  label: isArabic ? 'رقم المبنى' : 'Building No',
                  icon: Icons.home_work_outlined,
                  enabled: isAdmin,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildTextField(
                  controller: _postalCodeController,
                  label: isArabic ? 'الرمز البريدي' : 'Postal Code',
                  icon: Icons.markunread_mailbox_outlined,
                  enabled: isAdmin,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildTextField(
                  controller: _shortAddressController,
                  label: isArabic ? 'العنوان المختصر' : 'Short Address',
                  icon: Icons.pin_drop_outlined,
                  enabled: isAdmin,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 4. Receipt & Operations Tab
  Widget _buildReceiptOperationsTab(bool isAdmin, bool isArabic) {
    return BkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            isArabic ? 'إعدادات الفاتورة وساعات العمل' : 'Receipt & Operating Hours',
            Icons.receipt_long,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _headerNoteController,
            label: isArabic ? 'رسالة ترحيبية أعلى الفاتورة' : 'Receipt Header Note',
            icon: Icons.speaker_notes_outlined,
            enabled: isAdmin,
            maxLines: 2,
          ),
          const SizedBox(height: 14),
          _buildTextField(
            controller: _footerNoteController,
            label: isArabic ? 'رسالة ختامية أسفل الفاتورة' : 'Receipt Footer Note',
            icon: Icons.format_quote_outlined,
            enabled: isAdmin,
            maxLines: 2,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _openingTimeController,
                  label: isArabic ? 'وقت الافتتاح' : 'Opening Time',
                  icon: Icons.access_time,
                  enabled: isAdmin,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildTextField(
                  controller: _closingTimeController,
                  label: isArabic ? 'وقت الإغلاق' : 'Closing Time',
                  icon: Icons.access_time_filled,
                  enabled: isAdmin,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildTextField(
                  controller: _serviceChargeController,
                  label: isArabic ? 'رسوم الخدمة (%)' : 'Service Charge (%)',
                  icon: Icons.room_service_outlined,
                  enabled: isAdmin,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF2E7D64), size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D64),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF2E7D64)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: enabled
            ? Theme.of(context).colorScheme.surfaceContainerLowest
            : Colors.grey.shade100,
      ),
      validator: validator,
    );
  }

  Widget _buildActionFooter(
    BuildContext context,
    RestaurantEntity current,
    bool isArabic,
  ) {
    final state = context.watch<RestaurantCubit>().state;
    final isSaving = state is RestaurantLoaded && state.isSaving;

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: isSaving ? null : () => _handleSave(context, current),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D64),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              icon: isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.save),
              label: Text(
                isSaving
                    ? (isArabic ? 'جارٍ الحفظ...' : 'Saving...')
                    : (isArabic ? 'حفظ بيانات المطعم' : 'Save Restaurant Details'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
