// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../controllers/Loading_PageController.dart';

class LoadingView extends StatelessWidget {
  final LoadingController controller = Get.put(LoadingController());
  LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          controller.goBack();
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                'Sweet Weather',
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: Container(

              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topCenter,
                  stops: [0.2, 0.9],
                  colors: [
                    Color(0xff4b0f95),
                    Color(0xff022b4a),
                  ],
                ),
              ),
              child: SafeArea(
                child: Center(
                  child: Obx(
                    () => ListView(
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: controller.animationDuration),
                          curve: Curves.easeInOut,
                          height: controller.containersize,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              stops: [0.2, 0.9],
                              colors: [
                                Color(0xff955cd1),
                                Color(0xff3fa2fa),
                              ],
                            ),
                          ),
                          child: ListView(
                            children: [
                              Visibility(
                                visible: ( controller.percent.value < 100),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [
                                    const SizedBox(height: 40),
                                      CircularPercentIndicator(
                                      animation: true,
                                      animationDuration: 60000,
                                      radius: 130,
                                      lineWidth: 20,
                                      percent: 1,
                                      backgroundColor: controller.shadowColor,
                                      arcType: ArcType.FULL,
                                      arcBackgroundColor: const Color.fromARGB(
                                          98, 253, 212, 1),
                                      circularStrokeCap: CircularStrokeCap.round,
                                      linearGradient: const LinearGradient(
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.bottomRight,
                                        stops: [0.2, 0.9],
                                        colors: [
                                          Color.fromARGB(255, 253, 212, 1),
                                          Color.fromARGB(255, 252, 139, 0)
                                        ],
                                      ),
                                      center: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 70),
                                          Text(
                                            '${controller.percent.value}%',
                                            style: const TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Lottie.asset(
                                            'assets/lottie/waiting.json',
                                            width: 140,
                                            height: 140,
                                            fit: BoxFit.fill,
                                          ),
                                        ],
                                      )
                                    ),
                                    const SizedBox(height: 60),
                                    Center(
                                      child: Text(
                                        controller.messages[controller.messageIndex.value],
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: controller.percent.value >= 100,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 30),
                                ElevatedButton(
                                  onPressed: () {
                                    controller.reloadPage();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    backgroundColor: controller.backgroundColor,
                                    elevation: 10.0,
                                  ),
                                  child: SizedBox(
                                    width: 150,
                                    height: 150,
                                    child: AnimatedBuilder(
                                      animation: controller.animationController,
                                      builder: (context, child) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: controller.backgroundColor,
                                            boxShadow: [
                                              BoxShadow(
                                                color: controller.backgroundColor,
                                                blurRadius: controller.animation.value,
                                                spreadRadius: controller.animation.value,
                                              ),
                                            ],
                                          ),
                                          child: Lottie.asset('assets/lottie/sun.json'),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                    const SizedBox(height: 20),
                                    const Center(
                                      child: Text(
                                        'Cliquez sur le Soleil pour recommencer',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        Visibility(
                          visible: controller.percent.value >= 100,
                          child: Column(
                            children: [
                              DataTable(
                                columnSpacing: 20,
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Ville',
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Température',
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Météo',
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        '  ',
                                        style: TextStyle(fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: List<DataRow>.generate(
                                  // check if the list is empty
                                  controller.weathersData.isEmpty
                                      ? 0
                                      : controller.weathersData.length,
                                      (index) {
                                    final currentWeather = controller.weathersData[index];
                                    return DataRow(
                                      cells: <DataCell>[
                                        DataCell(
                                          Text(
                                            currentWeather.name,
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            '${currentWeather.temp}°C',
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            currentWeather.description,
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        DataCell(Image.network(currentWeather.icon)),
                                      ],
                                      color: MaterialStateProperty.resolveWith<Color?>(
                                            (Set<MaterialState> states) {
                                          if (states.contains(MaterialState.selected)) {
                                            return Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(0.08);
                                          }
                                          if (index.isEven) {
                                            return Colors.grey.withOpacity(0.3);
                                          }
                                          return null; // Use default value for other states and odd rows.
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }
}
