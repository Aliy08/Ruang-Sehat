import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ruang_sehat/features/articles/presentation/screens/form_article_screen.dart';

class PopupMenu extends StatelessWidget{
  const PopupMenu ({super.key});

  @override
  Widget build (BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          width: 180,
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.white),
                title: const Text(
                  'Edit Article',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context, 
                    FormArticleScreen.routeName,
                    arguments: {'isEdit' : true},
                  );
                }
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Delete Article',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}