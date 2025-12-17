import 'package:flutter/material.dart';
import 'package:view360/common/theme/colors.dart';
import 'package:view360/view/widgets/appbar_widget/appbar_widget.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  int selectedCategoryIndex = 0;
  List<Map<String, String>> currentFAQs = [];

  final List<Map<String, String>> financialFAQs = [
    {
      'question': 'What is the return policy?',
      'answer':
          'You can return the product within 30 days of purchase if it is in its original condition.',
    },
    {
      'question': 'What payment methods are available?',
      'answer': 'We accept credit cards, bank cards, and digital wallets.',
    },
  ];

  final List<Map<String, String>> technicalFAQs = [
    {
      'question': 'How can I update the app?',
      'answer': 'You can update the app from your device’s app store.',
    },
    {
      'question': 'What should I do if I encounter a technical issue?',
      'answer': 'Please contact technical support through the "Support" page.',
    },
  ];

  final List<Map<String, String>> auctionFAQs = [
    {
      'question': 'How can I participate in auctions?',
      'answer':
          'You can participate by registering in the app and navigating to the auctions section.',
    },
    {
      'question': 'What are the conditions for participating in auctions?',
      'answer': 'You must be registered and agree to the terms and conditions.',
    },
  ];

  @override
  void initState() {
    super.initState();
    currentFAQs = financialFAQs; // Default category
  }

  void updateFAQs(int index) {
    setState(() {
      selectedCategoryIndex = index;
      switch (index) {
        case 0:
          currentFAQs = financialFAQs;
          break;
        case 1:
          currentFAQs = technicalFAQs;
          break;
        case 2:
          currentFAQs = auctionFAQs;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _buildAskQuestionButton(),
      ),
      appBar: AppbarWidget(title: 'FAQs'),
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 10),
          //  Search(),
          const SizedBox(height: 10),
          _buildCategoryButtons(),
          const SizedBox(height: 10),
          _buildFAQList(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 50,
      width: double.infinity,
      color: Colors.grey,
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.question_answer, color: Colors.white),
          const SizedBox(width: 8),
          const Text(
            "Frequently Asked Questions",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButtons() {
    final categories = ['Financial', 'Technical', 'Auctions'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(categories.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedCategoryIndex == index
                  ? darkBlue
                  : Colors.white,
              foregroundColor: selectedCategoryIndex == index
                  ? Colors.white
                  : darkBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
                side: BorderSide(color: black, width: 1.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            ),
            onPressed: () => updateFAQs(index),
            child: Text(categories[index]),
          ),
        );
      }),
    );
  }

  Widget _buildFAQList() {
    return Expanded(
      child: ListView.builder(
        itemCount: currentFAQs.length,
        itemBuilder: (context, index) {
          final faq = currentFAQs[index];
          return _buildFAQTile(faq);
        },
      ),
    );
  }

  Widget _buildFAQTile(Map<String, String> faq) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.5),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ExpansionTile(
        iconColor: grey100,
        collapsedIconColor: grey100,
        title: Text(
          faq['question']!,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: darkBlue,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              faq['answer']!,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAskQuestionButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => const AskQuestionDialog(),
        );
      },
      child: const Text("Ask a Question"),
    );
  }
}

class AskQuestionDialog extends StatelessWidget {
  const AskQuestionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Ask a Question",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Enter your question here",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: darkBlue),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
