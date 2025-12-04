import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/oracle/category_model.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/creator_providers.dart';
import '../widgets/quiz_type_selector.dart';
import 'create_quiz_step2_page.dart';

/// Step 1 of the Quiz Creator
/// Collects: Quiz Type, Title, Description, Category
class CreateQuizStep1Page extends ConsumerStatefulWidget {
  const CreateQuizStep1Page({super.key});

  @override
  ConsumerState<CreateQuizStep1Page> createState() =>
      _CreateQuizStep1PageState();
}

class _CreateQuizStep1PageState extends ConsumerState<CreateQuizStep1Page> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Local form state
  QuizType _selectedType = QuizType.quiz;
  CategoryModel? _selectedCategory;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool get _isFormValid =>
      _titleController.text.trim().isNotEmpty && _selectedCategory != null;

  void _handleNext() {
    if (!_isFormValid) {
      // Show validation error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _titleController.text.trim().isEmpty
                      ? 'Tytuł jest wymagany'
                      : 'Wybierz kategorię',
                ),
              ),
            ],
          ),
          backgroundColor: AppTheme.errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    // Create draft state and print to console
    final formState = CreatorFormState(
      type: _selectedType,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      selectedCategory: _selectedCategory,
    );

    // Save form state to provider for Step 2
    ref.read(creatorFormStateProvider.notifier).state = formState;

    debugPrint('═══════════════════════════════════════════');
    debugPrint('📝 Draft created:');
    debugPrint('   Type: ${formState.type.label}');
    debugPrint('   Title: ${formState.title}');
    debugPrint('   Description: ${formState.description}');
    debugPrint('   Category: ${formState.selectedCategory?.name} (ID: ${formState.selectedCategory?.id})');
    debugPrint('═══════════════════════════════════════════');

    // Show success snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Draft utworzony: ${formState.title} [${formState.selectedCategory?.name}]',
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // Navigate to Step 2
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CreateQuizStep2Page(),
      ),
    );
  }

  void _handleCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nowy Quiz'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handleCancel,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable form content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Step indicator
                      _buildStepIndicator(theme),
                      const SizedBox(height: 28),

                      // Quiz Type Selector
                      QuizTypeSelector(
                        selectedType: _selectedType,
                        onTypeChanged: (type) {
                          setState(() => _selectedType = type);
                        },
                      ),
                      const SizedBox(height: 24),

                      // Title Field
                      _buildTitleField(theme),
                      const SizedBox(height: 20),

                      // Description Field
                      _buildDescriptionField(theme),
                      const SizedBox(height: 20),

                      // Category Dropdown
                      _buildCategoryDropdown(theme, categoriesAsync),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom action buttons
            _buildBottomActions(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '1',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Krok 1 z 3',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                Text(
                  'Podstawowa konfiguracja',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Tytuł',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(width: 4),
            Text(
              '*',
              style: TextStyle(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            hintText: 'Wprowadź tytuł quizu...',
            prefixIcon: Icon(Icons.title),
          ),
          textInputAction: TextInputAction.next,
          onChanged: (_) => setState(() {}), // Refresh to update button state
        ),
      ],
    );
  }

  Widget _buildDescriptionField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Opis (opcjonalny)',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            hintText: 'Krótki opis quizu...',
            prefixIcon: Icon(Icons.description_outlined),
            alignLabelWithHint: true,
          ),
          maxLines: 3,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown(
    ThemeData theme,
    AsyncValue<List<CategoryModel>> categoriesAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Kategoria',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(width: 4),
            Text(
              '*',
              style: TextStyle(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        categoriesAsync.when(
          // Loading state
          loading: () => Container(
            height: 56,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.dividerColor),
            ),
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),

          // Error state
          error: (error, stack) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.errorColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.errorColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: AppTheme.errorColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Błąd pobierania kategorii',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.errorColor,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: AppTheme.errorColor,
                  ),
                  onPressed: () => ref.invalidate(categoriesProvider),
                  tooltip: 'Ponów',
                ),
              ],
            ),
          ),

          // Data state
          data: (categories) => DropdownButtonFormField<CategoryModel>(
            value: _selectedCategory,
            decoration: const InputDecoration(
              hintText: 'Wybierz kategorię',
              prefixIcon: Icon(Icons.category_outlined),
            ),
            items: categories.map((category) {
              return DropdownMenuItem<CategoryModel>(
                value: category,
                child: Text(category.name ?? 'Bez nazwy'),
              );
            }).toList(),
            onChanged: (category) {
              setState(() => _selectedCategory = category);
            },
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Cancel button
          Expanded(
            child: OutlinedButton(
              onPressed: _handleCancel,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: theme.colorScheme.outline),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Anuluj'),
            ),
          ),
          const SizedBox(width: 16),
          // Next button
          Expanded(
            flex: 2,
            child: FilledButton(
              onPressed: _isFormValid ? _handleNext : null,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: _isFormValid
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.12),
                foregroundColor: _isFormValid
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.38),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Dalej',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward,
                    size: 20,
                    color: _isFormValid
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface.withValues(alpha: 0.38),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

