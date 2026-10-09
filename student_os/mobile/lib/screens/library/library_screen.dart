import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/library_models.dart';
import '../../providers/library_provider.dart';
import '../../widgets/ai/ai_copilot_button.dart';
import '../../widgets/app_bottom_sheet.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_dialog.dart';
import '../../widgets/empty_state.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _openAiLibraryAssistant(BuildContext context) {
    final colors = AppColors.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        String? selectedPrompt;
        String? aiAnswer;

        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            return Container(
              height: MediaQuery.of(modalCtx).size.height * 0.78,
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                border: Border(
                  top: BorderSide(color: colors.border, width: 1),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: colors.elevatedCard,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: colors.border, width: 1),
                              ),
                              child: Icon(Icons.auto_awesome, color: colors.primary, size: 18),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'AI Library Assistant',
                                  style: GoogleFonts.outfit(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: colors.primaryText,
                                  ),
                                ),
                                Text(
                                  'Smart reading plans & inventory recommendations',
                                  style: GoogleFonts.inter(fontSize: 11.5, color: colors.secondaryText),
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.close_rounded, size: 20, color: colors.secondaryText),
                          onPressed: () => Navigator.pop(modalCtx),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        Text(
                          'SUGGESTED QUERIES',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                            color: colors.primaryText,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            'Which books should I read for Machine Learning?',
                            'Recommend books for Compiler Design',
                            'Find books related to Computer Vision',
                            'What should I read before learning Deep Learning?',
                            'Best books for Distributed Systems',
                          ].map((p) {
                            final isSel = selectedPrompt == p;
                            return ActionChip(
                              label: Text(p, style: GoogleFonts.inter(fontSize: 12, color: isSel ? Colors.white : colors.secondaryText)),
                              backgroundColor: isSel ? colors.primary : colors.elevatedCard,
                              side: BorderSide(
                                color: isSel ? colors.primary : colors.border,
                              ),
                              onPressed: () {
                                setModalState(() {
                                  selectedPrompt = p;
                                  aiAnswer = _getAiLibraryAnswer(p);
                                });
                              },
                            );
                          }).toList(),
                        ),
                        if (aiAnswer != null) ...[
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colors.card,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: colors.border,
                              ),
                              boxShadow: [
                                colors.cardShadow,
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.menu_book_outlined, size: 16, color: colors.primary),
                                    const SizedBox(width: 8),
                                    Text(
                                      'AI Recommendation & Sequence',
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: colors.primaryText,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  aiAnswer!,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    height: 1.5,
                                    color: colors.secondaryText,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: colors.elevatedCard,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: colors.border, width: 0.8),
                                  ),
                                  child: Text(
                                    '✓ Prioritized based on campus library stock (Stack 3, Bay B)',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: colors.primaryText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _getAiLibraryAnswer(String query) {
    if (query.contains('Machine Learning') || query.contains('Deep Learning')) {
      return '📚 **Recommended ML Reading Roadmap**:\n\n'
          '1. **Level 1 (Foundations)**: *Introduction to Algorithms (CLRS)* — Master basic optimization & complexity.\n'
          '2. **Level 2 (Core Deep Learning)**: *Deep Learning with Python* by François Chollet (Available on Stack 3, Bay B). Focus on Chapters 3-7 (Dense nets, CNNs, and embeddings).\n'
          '3. **Level 3 (Advanced)**: *Attention Is All You Need* (Available in Digital Resources tab) for Transformer mechanisms.\n\n'
          '⏱️ **Estimated Pacing**: 2 chapters per week with hands-on PyTorch/Keras notebooks.';
    } else if (query.contains('Compiler')) {
      return '⚙️ **Recommended Compiler Design Path**:\n\n'
          '1. **Textbook**: *Compilers: Principles, Techniques, & Tools (Dragon Book)* by Aho, Lam, Sethi, Ullman (Stack 1, Bay A — 3 copies available).\n'
          '2. **Key Units**: Focus on Lexical Analysis (Flex), LL(1) / LR(1) Parsers (Bison), and Three-Address Code generation.\n'
          '3. **Supplementary**: Check Department Handout in Digital Resources (Unit 1 to 5 summary).';
    } else if (query.contains('Vision')) {
      return '👁️ **Computer Vision Sequence**:\n\n'
          '1. *Computer Vision: Algorithms & Applications* by Richard Szeliski (Stack 3, Bay B).\n'
          '2. Study camera projection matrices, convolution filters, and then transition to CNN Feature Pyramids & YOLO detection models.';
    } else {
      return '🌐 **Distributed Systems & Cloud Path**:\n\n'
          '1. *Designing Data-Intensive Applications* by Martin Kleppmann (Stack 5, Bay D).\n'
          '2. Focus on Raft consensus, CAP Theorem trade-offs, and partition recovery mechanisms.';
    }
  }

  void _openBookDetail(BuildContext context, LibraryBook book) {
    final colors = AppColors.of(context);
    AppBottomSheet.show(
      context,
      title: book.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                  color: colors.elevatedCard,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colors.border, width: 1),
                ),
                child: Icon(Icons.menu_book_outlined, color: colors.primary, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.author,
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: colors.primaryText),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'ISBN: ${book.isbn}',
                      style: GoogleFonts.inter(fontSize: 11, color: colors.secondaryText),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star_outline_rounded, size: 14, color: colors.warning),
                        const SizedBox(width: 4),
                        Text(
                          '${book.rating} / 5.0',
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: colors.primaryText),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Overview',
            style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700, color: colors.primaryText),
          ),
          const SizedBox(height: 4),
          Text(
            book.description,
            style: GoogleFonts.inter(fontSize: 13, height: 1.45, color: colors.secondaryText),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.elevatedCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.border, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Location', style: GoogleFonts.inter(fontSize: 11, color: colors.mutedText)),
                    Text(book.shelfLocation, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: colors.primaryText)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Availability', style: GoogleFonts.inter(fontSize: 11, color: colors.mutedText)),
                    Text(
                      '${book.availableCopies} of ${book.totalCopies} Available',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: colors.primaryText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          AppButton(
            text: book.availableCopies > 0 ? 'Borrow / Reserve Book' : 'Out of Stock (Join Waitlist)',
            width: double.infinity,
            onPressed: () {
              Navigator.pop(context);
              if (book.availableCopies > 0) {
                context.read<LibraryProvider>().borrowBook(book);
                AppDialog.show(
                  context,
                  title: 'Book Reserved!',
                  content: 'You have reserved "${book.title}". Pick it up from ${book.shelfLocation} within 24 hours.',
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final libraryProvider = context.watch<LibraryProvider>();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Campus Library',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors.primaryText,
              ),
            ),
            Text(
              'Search books, track dues & digital resources',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: colors.secondaryText,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: AICopilotButton(
              label: 'AI Books',
              icon: Icons.auto_awesome,
              onPressed: () => _openAiLibraryAssistant(context),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: colors.primary,
          labelColor: colors.primaryText,
          unselectedLabelColor: colors.mutedText,
          labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
          tabs: [
            const Tab(text: 'Catalog'),
            Tab(text: 'My Books (${libraryProvider.activeBorrowed.length})'),
            const Tab(text: 'Digital E-Books'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. Catalog Tab
          _buildCatalogTab(context, libraryProvider, colors),

          // 2. My Books Tab
          _buildMyBooksTab(context, libraryProvider, colors),

          // 3. Digital Resources Tab
          _buildDigitalTab(context, libraryProvider, colors),
        ],
      ),
    );
  }

  Widget _buildCatalogTab(BuildContext context, LibraryProvider provider, AppColorPalette colors) {
    final categories = ['ALL', 'CSE', 'AIML', 'IT', 'Core AI', 'Systems', 'Networks'];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Search bar
        TextField(
          controller: _searchController,
          onChanged: (val) => provider.setSearchQuery(val),
          style: GoogleFonts.inter(fontSize: 13, color: colors.primaryText),
          decoration: InputDecoration(
            hintText: 'Search books, authors, ISBN, subjects...',
            prefixIcon: Icon(Icons.search_rounded, size: 20, color: colors.primary),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear_rounded, size: 18, color: colors.secondaryText),
                    onPressed: () {
                      _searchController.clear();
                      provider.setSearchQuery('');
                    },
                  )
                : null,
          ),
        ),
        const SizedBox(height: 12),

        // Department Chips
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (ctx, i) {
              final cat = categories[i];
              final isSel = provider.selectedCategory == cat;
              return ChoiceChip(
                label: Text(cat, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: isSel ? Colors.white : colors.secondaryText)),
                selected: isSel,
                selectedColor: colors.primary,
                backgroundColor: colors.card,
                side: BorderSide(
                  color: isSel ? colors.primary : colors.border,
                ),
                onSelected: (_) => provider.setSelectedCategory(cat),
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        // Books List
        if (provider.filteredBooks.isEmpty)
          const AppEmptyState(
            icon: Icons.search_off_rounded,
            title: 'No Books Found',
            description: 'Try adjusting your search query or department filter.',
          )
        else
          ...provider.filteredBooks.map((book) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                onTap: () => _openBookDetail(context, book),
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 64,
                      decoration: BoxDecoration(
                        color: colors.elevatedCard,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colors.border, width: 1),
                      ),
                      child: Center(
                        child: Icon(Icons.auto_stories_outlined, color: colors.primary, size: 24),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: colors.primaryText,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'By ${book.author}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(fontSize: 11.5, color: colors.secondaryText),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: colors.elevatedCard,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: colors.border, width: 0.8),
                                ),
                                child: Text(
                                  book.shelfLocation,
                                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: colors.primaryText),
                                ),
                              ),
                              Text(
                                '${book.availableCopies} available',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: colors.primaryText,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildMyBooksTab(BuildContext context, LibraryProvider provider, AppColorPalette colors) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Fines summary card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.border, width: 1),
            boxShadow: [
              colors.cardShadow,
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildFineItem('Current Fine', '₹${provider.fines.currentFine.toStringAsFixed(0)}', colors),
              Container(width: 1, height: 32, color: colors.border),
              _buildFineItem('Paid Fine', '₹${provider.fines.paidFine.toStringAsFixed(0)}', colors),
              Container(width: 1, height: 32, color: colors.border),
              _buildFineItem('Pending Fine', '₹${provider.fines.pendingFine.toStringAsFixed(0)}', colors),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Text(
          'ACTIVE BORROWED BOOKS (${provider.activeBorrowed.length})',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
            color: colors.primaryText,
          ),
        ),
        const SizedBox(height: 10),

        if (provider.activeBorrowed.isEmpty)
          const AppEmptyState(
            icon: Icons.library_books_outlined,
            title: 'No Borrowed Books',
            description: 'Explore the catalog to borrow textbooks, guides, and reference material.',
          )
        else
          ...provider.activeBorrowed.map((b) {
            final isDueSoon = b.isDueSoon;
            final isOverdue = b.isOverdue;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            b.bookTitle,
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: colors.primaryText,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isOverdue
                                ? colors.danger.withValues(alpha: 0.12)
                                : (isDueSoon ? colors.warning.withValues(alpha: 0.12) : colors.elevatedCard),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isOverdue
                                  ? colors.danger.withValues(alpha: 0.4)
                                  : (isDueSoon ? colors.warning.withValues(alpha: 0.4) : colors.border),
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            isOverdue ? 'OVERDUE' : (isDueSoon ? 'DUE SOON' : 'ACTIVE'),
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: isOverdue
                                  ? colors.danger
                                  : (isDueSoon ? colors.warning : colors.primaryText),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'By ${b.author}',
                      style: GoogleFonts.inter(fontSize: 12, color: colors.secondaryText),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Due Date', style: GoogleFonts.inter(fontSize: 11, color: colors.mutedText)),
                            Text(
                              '${b.dueDate.day}/${b.dueDate.month}/${b.dueDate.year}',
                              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: colors.primaryText),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Days Left', style: GoogleFonts.inter(fontSize: 11, color: colors.mutedText)),
                            Text(
                              '${b.daysRemaining} days',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isOverdue ? colors.danger : colors.primaryText,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            provider.renewBook(b.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Book renewed for +14 additional days!')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.card,
                            foregroundColor: colors.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: colors.border),
                            ),
                          ),
                          child: Text('Renew +14d', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildFineItem(String label, String value, AppColorPalette colors) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: colors.primaryText)),
        const SizedBox(height: 2),
        Text(label, style: GoogleFonts.inter(fontSize: 11, color: colors.secondaryText)),
      ],
    );
  }

  Widget _buildDigitalTab(BuildContext context, LibraryProvider provider, AppColorPalette colors) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'COLLEGE DIGITAL REPOSITORY',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
            color: colors.primaryText,
          ),
        ),
        const SizedBox(height: 12),
        ...provider.digitalResources.map((res) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AppCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colors.elevatedCard,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: colors.border, width: 0.8),
                    ),
                    child: Icon(Icons.picture_as_pdf_outlined, color: colors.primary, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          res.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w700, color: colors.primaryText),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${res.authorOrPublisher} • ${res.fileSize} • ${res.year}',
                          style: GoogleFonts.inter(fontSize: 11, color: colors.secondaryText),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.download_outlined, color: colors.primary),
                    onPressed: () {
                      AppDialog.show(
                        context,
                        title: 'Resource Ready',
                        content: 'Opening "${res.title}" (${res.fileSize}). Stored securely in your offline student cache.',
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
