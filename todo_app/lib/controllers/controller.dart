import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/components/elements.dart';
import 'package:todo_app/models/tasks.dart';

class MainController extends GetxController {
  var task = [].obs;
  var imp = 0.obs;
  var day = 0.obs;

  Database? database;
  @override
  void onInit() {
    openDb();
    super.onInit();
  }

  Future openDb() async {
    // open the database
    database = await openDatabase(
      "task2.db",
      version: 1,
      onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute(
            'CREATE TABLE Task (id INTEGER PRIMARY KEY, title TEXT, time TEXT, description TEXT,day INTEGER,done INTEGER, importance INTEGER)');
      },
      onOpen: (Database db) async {
        database = db;
        await getData();
      },
    );
  }

  Future getData() async {
    task.value = (await database!.rawQuery("SELECT * FROM Task"))
        .map(
          (e) => Task(
            id: int.parse(
              e["id"].toString(),
            ),
            title: e["title"].toString(),
            time: e["time"].toString(),
            description: e["description"].toString(),
            day: int.parse(
              e["day"].toString(),
            ),
            done: int.parse(
                  e["day"].toString(),
                ) ==
                1,
            importance: int.parse(
              e["importance"].toString(),
            ),
          ),
        )
        .toList();
  }

  Future addTask(title, time, description, day, importance) async {
    await database!.transaction((txn) async {
      var n = await txn.rawInsert(
          "INSERT INTO Task(title,time,description,day,done,importance) VALUES (?, ?, ?, ?, ?, ?)",
          [
            title,
            time,
            description,
            day,
            0,
            importance,
          ]);
    });

    await getData();
  }

  add(context) {
    MainController c = Get.put(MainController());
    final days = ["MON", "THE", "WEN", "THR", "FRI", "SAT", "SUN"];
    TextEditingController title = TextEditingController();
    TextEditingController desckription = TextEditingController();
    TextEditingController time = TextEditingController();
    GlobalKey<FormState> fkey = GlobalKey<FormState>();
    Get.bottomSheet(
      Obx(
        () => Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: fkey,
            child: ListView(
              children: [
                buildInputFeild(
                  title,
                  "Task Title",
                  (v) {},
                ),
                buildInputFeild(desckription, "Task Description", (v) {},
                    maxLines: 4),
                buildInputFeild(time, "Start in", (v) {
                  if (int.tryParse(v) == null ||
                      int.tryParse(v)! > 24 ||
                      int.tryParse(v)! < 0) {
                    return 'invalid time';
                  }
                }, keyTyp: TextInputType.number),
                const Text(
                  "What Day:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (int i = 0; i < 7; i++)
                        GestureDetector(
                          onTap: () {
                            c.day.value = i + 1;
                          },
                          child: Container(
                            margin: const EdgeInsetsDirectional.all(3),
                            padding: const EdgeInsetsDirectional.all(5),
                            height: MediaQuery.of(context).size.height / 15,
                            width: MediaQuery.of(context).size.width / 9,
                            decoration: BoxDecoration(
                                color: c.day.value == i + 1
                                    ? Colors.amber
                                    : const Color.fromARGB(255, 217, 217, 217),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Text(
                              days[i],
                              style: TextStyle(
                                color: c.day.value != i + 1
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const Text(
                  "Importance",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Slider(
                  activeColor: Color.fromRGBO(255, 255 - c.imp.value, 50, 1),
                  onChanged: (v) {
                    if (c.imp.value < 255) {
                      c.imp.value = v.toInt();
                    }
                  },
                  value: c.imp.value.toDouble(),
                  max: 255,
                  min: 0,
                ),
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: MaterialButton(
                    onPressed: () async {
                      await addTask(
                        title.text,
                        time.text,
                        desckription.text,
                        day.value,
                        imp.value,
                      );
                      Navigator.of(context).pop();
                    },
                    child: const Text("Add"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(15),
        topLeft: Radius.circular(15),
      )),
      backgroundColor: Colors.white,
    );
  }

  Future delete(id) async {
    await database!.rawDelete("DELETE FROM Task WHERE id = ?",[id]);
    await getData();
  }
}
