import 'package:flutter/material.dart';
import 'package:ruang_sehat/theme/app_colors.dart';

class FormArticleScreen extends StatefulWidget {
  const FormArticleScreen({super.key});

  static const routeName = '/form-article';

  @override
  State<FormArticleScreen> createState() => _FormArticleScreenState();
}

class _FormArticleScreenState extends State<FormArticleScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final isEdit = args['isEdit'] ?? false;
    final articleId = args['articleId'];

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            isEdit ? 'Update Artikel' : 'Create Artikel',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppColors.background,
          leading: IconButton(
              padding: EdgeInsets.only(left: 20),
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label form title
              Text(
                'Title',
                style: TextStyle(
                  color: Color(0xFF4D4637),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              // Form title
              const SizedBox(height: 5),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  fillColor: AppColors.secondary,
                  filled: true,
                  hintText: 'Enter the Article Title',
                  isDense: true,
                  hintStyle: const TextStyle(
                    color: AppColors.hintText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.border,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.border,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 15,
                  ),
                ),
              ),

              // Label Form category
              const SizedBox(height: 10),
              Text(
                'Category',
                style: TextStyle(
                  color: Color(0xFF4D4637),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              // Form category
              const SizedBox(height: 5),
              TextFormField(
                controller: categoryController,
                decoration: InputDecoration(
                  fillColor: AppColors.secondary,
                  filled: true,
                  hintText: 'Enter the Article Category',
                  isDense: true,
                  hintStyle: const TextStyle(
                    color: AppColors.hintText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.border,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.border,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 15,
                  ),
                ),
              ),

              // Label Form description
              const SizedBox(height: 10),
              Text(
                'Description',
                style: TextStyle(
                  color: Color(0xFF4D4637),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              // Form Description
              const SizedBox(height: 5),
              TextFormField(
                maxLines: 8,
                minLines: 8,
                keyboardType: TextInputType.multiline,
                controller: descriptionController,
                decoration: InputDecoration(
                  fillColor: AppColors.secondary,
                  filled: true,
                  hintText: 'Enter the Article Title',
                  isDense: true,
                  hintStyle: const TextStyle(
                    color: AppColors.hintText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.border,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.border,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: () async {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              isEdit ? 'Update' : 'Create',
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
