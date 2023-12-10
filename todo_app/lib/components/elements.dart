import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controllers/controller.dart';
import 'package:todo_app/models/tasks.dart';

dayInTable(context, String day, index, List tasks, MainController c) {
  final mesure = ((MediaQuery.of(context).size.width / 6) * 5) / 12;

  return Row(
    children: [
      Container(
        padding: const EdgeInsetsDirectional.all(5),
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height / 8,
        width: (MediaQuery.of(context).size.width / 6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.black, width: 1)),
        child: Text(
          day,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        width: (MediaQuery.of(context).size.width / 6) * 5,
        height: MediaQuery.of(context).size.height / 8,
        padding: const EdgeInsetsDirectional.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount:
              tasks.length, // Adjust the itemCount as per your requirement
          itemBuilder: (BuildContext context, int index) {
            return task(mesure, tasks[index], context, c);
          },
        ),
      ),
    ],
  );
}

task(mesure, Task task, context, MainController c) {
  return GestureDetector(
    onTap: () {
      Get.bottomSheet(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
          )),
          Column(
            children: [
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                padding: const EdgeInsetsDirectional.all(10),
                margin: const EdgeInsetsDirectional.all(20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                child: Text(
                  task.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                padding: const EdgeInsetsDirectional.all(10),
                margin: const EdgeInsetsDirectional.all(15),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                child: Text(
                  task.description,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                padding: const EdgeInsetsDirectional.all(10),
                margin: const EdgeInsetsDirectional.all(15),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                child: Text(
                  "in : ${task.time}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: MaterialButton(
                  onPressed: () async {
                    await c.delete(task.id);
                    Navigator.of(context).pop();
                  },
                  child: const Text("Delete"),
                ),
              )
            ],
          ));
    },
    child: Container(
      margin: const EdgeInsetsDirectional.all(5),
      padding: const EdgeInsetsDirectional.all(5),
      width: mesure * 5,
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255 - (task.importance), 50, 1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: mesure*2,
            child: Text(
              task.title,
              style: const TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
           SizedBox(
            width: mesure*3/2,
          ),
          SizedBox(
            width: mesure,
            child: Text(
              '${task.time}',
              style: const TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    ),
  );
}

Widget buildInputFeild(controller, hint, validator,
        {keyTyp = TextInputType.text, int maxLines = 1}) =>
    Container(
      padding: const EdgeInsetsDirectional.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        maxLines: maxLines,
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
          hintTextDirection: TextDirection.ltr,
          hintText: hint,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        keyboardType: keyTyp,
      ),
    );
