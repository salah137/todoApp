import "package:flutter/material.dart";
import 'package:get/get.dart';
import "package:todo_app/components/elements.dart";
import "package:todo_app/controllers/controller.dart";

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final days = ["MON", "THE", "WEN", "THR", "FRI", "SAT", "SUN"];
    final MainController controller = Get.put(MainController());

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amberAccent,
          title: const Text("My Weekly plane",style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (int i = 0; i < 7; i++)
              dayInTable(
                context,
                days[i],
                i + 1,
                controller.task.value
                    .where((element) => element.day == i + 1)
                    .toList(),
                controller,
              )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.add(context);
          },
          backgroundColor: Colors.amber,
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}
