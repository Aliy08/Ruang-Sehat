import 'package:flutter/material.dart';
import 'package:ruang_sehat/theme/app_colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:ruang_sehat/features/articles/providers/articles_provider.dart';
import 'package:ruang_sehat/features/articles/presentation/screens/detail_screen.dart';

class FeaturedCard extends StatelessWidget {
  const FeaturedCard({super.key});
  static final String baseUrl = dotenv.env['BASE_URL']!;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Consumer<ArticlesProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.articles.isEmpty) {
            return const Center(child: Text('Tidak ada artikel'));
          }
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: provider.articles.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
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
                child: SizedBox(
                  width: 260,
                  child: Card(
                    color: AppColors.secondary,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          //image
                          Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 196,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      '$baseUrl/${article.image}',
                                    ),
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topCenter,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                left: 10,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                  child: Text(
                                    article.category,
                                    style: TextStyle(
                                      color: AppColors.secondary,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          //title
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '🔥Trending no ${index + 1}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.hintText,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        article.date,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.hintText,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      article.tittle,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
