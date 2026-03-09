import 'package:flutter/material.dart';
import 'package:money_manager_app/model/eventmodel.dart';
import 'package:open_file/open_file.dart';

class EventSummaryScreen extends StatefulWidget {
  final EventModel event;

  const EventSummaryScreen({super.key, required this.event});

  @override
  State<EventSummaryScreen> createState() => _EventSummaryScreenState();
}

class _EventSummaryScreenState extends State<EventSummaryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;

    return FadeTransition(
      opacity: controller,
      child: Scaffold(
        backgroundColor: const Color(0xff0F172A),
        appBar: AppBar(
          backgroundColor: const Color(0xff0F172A),
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Event Summary",
            style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _animatedTile(0, _tile("Event Name", event.name, Icons.event)),
            _animatedTile(
                1, _tile("Category", event.category ?? "General", Icons.category)),
            _animatedTile(2, _tile("Status", event.status, Icons.flag)),
            _animatedTile(
                3, _tile("Payment Type", event.paymentType, Icons.payment)),
            _animatedTile(
                4, _tile("Members", event.members.toString(), Icons.people)),
            const SizedBox(height: 16),
            _animatedTile(
              5,
              _amountTile(
                "Total Amount",
                "₹${event.totalAmount.toStringAsFixed(2)}",
              ),
            ),
            _animatedTile(
              6,
              _amountTile(
                "Split Amount",
                "₹${event.splitAmount?.toStringAsFixed(2) ?? '0.00'}",
              ),
            ),
            _animatedTile(
              7,
              _amountTile(
                "Total Expense",
                "₹${((event.splitAmount ?? 0) * event.members).toStringAsFixed(2)}",
                highlight: true,
              ),
            ),
            if (event.attachmentPath != null) ...[
              const SizedBox(height: 16),
              _animatedTile(8, _attachmentTile(event.attachmentPath!)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _animatedTile(int index, Widget child) {
    final animation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          (index * 0.1).clamp(0.0, 1.0),
          1,
          curve: Curves.easeOut,
        ),
      ),
    );

    return SlideTransition(
      position: animation,
      child: FadeTransition(
        opacity: controller,
        child: child,
      ),
    );
  }

  Widget _tile(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff1E293B),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.amber, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _amountTile(String title, String value, {bool highlight = false}) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.8, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: highlight ? const Color(0xff334155) : const Color(0xff1E293B),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: highlight ? Colors.amber : Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _attachmentTile(String path) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.9, end: 1),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: InkWell(
        onTap: () => OpenFile.open(path),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xff1E293B),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.amber),
          ),
          child: Row(
            children: [
              const Icon(Icons.attach_file, color: Colors.amber),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  path.split('/').last,
                  style: const TextStyle(color: Colors.amber),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.open_in_new, color: Colors.amber, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}