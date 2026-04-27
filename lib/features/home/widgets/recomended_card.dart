import 'package:flutter/material.dart';
import 'package:ruang_sehat/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:ruang_sehat/features/articles/providers/articles_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ruang_sehat/features/articles/presentation/screens/detail_screen.dart';

class RecomendedCard extends StatelessWidget {
  const RecomendedCard({super.key});
  static final String baseUrl = dotenv.env['BASE_URL']!;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ArticlesProvider>();
    final articles = provider.articles;

    if (provider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (articles.isEmpty) {
      return Text("Tidak ada artikel");
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => const SizedBox(height: 7),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = provider.articles[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              DetailScreen.routeName,
              arguments: {'id': article.id},
            );
          },
          child: Card(
            color: AppColors.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Row(
                children: [
                  // Image articles
                  Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage("assets/images/artikel1.jpg"),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),

                  // Articles title
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.3),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(99)),
                                ),
                                child: Center(
                                  child: Text(
                                    'Healty Tips',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                '2026-01-27',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.hintText,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'The Benefits of Running and Tips to Get Started',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
