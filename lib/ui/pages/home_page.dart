import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:geohash_reverse_geocode/models/geohash_dataset.dart';
import 'package:geohash_reverse_geocode/ui/pages/web_home.dart';
import 'package:get/get.dart';

import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../controllers/geohash_controller.dart';
import 'mobile_home.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isDialogOpen = false;

  final GeoHashController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: GetBuilder<GeoHashController>(
        builder: (controller) => SafeArea(
          child: kIsWeb
              ? WebHome(
                  addEditGeoHashData: () => addEditGeoHashData(context),
                  isDialogOpen: _isDialogOpen,
                )
              : MobileHome(
                  onAddEditGeoHashData: () => addEditGeoHashData(context),
                  isDialogOpen: _isDialogOpen,
                  width: width,
                  height: height),
        ),
      ),
    );
  }

  addEditGeoHashData(BuildContext context) {
    addGeoHashDataSet(context, controller.geoHashDataSet!,
        onTap: (description, provinceName, ward, Color color) {
      controller.updateGeohashDataSet(description, provinceName, ward, color);
    });
  }

  addGeoHashDataSet(
    BuildContext context,
    GeoHashDataSet geoHashDataSet, {
    required Function(
            String description, String provinceName, String ward, Color color)
        onTap,
  }) {
    setState(() {
      _isDialogOpen = true;
    });
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController provinceNameController =
        TextEditingController();
    final TextEditingController wardController = TextEditingController();
    descriptionController.text = geoHashDataSet.description;
    provinceNameController.text = geoHashDataSet.metaTag.provinceInfo;
    wardController.text = geoHashDataSet.metaTag.ward.toString();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          final width = MediaQuery.of(ctx).size.width;
          Color selectedColor =
              colorFromHex(controller.geoHashDataSet?.color ?? '#ffffff') ??
                  Colors.red;
          return StatefulBuilder(
            builder: (context, StateSetter updateState) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: SafeArea(
                  child: Center(
                    child: Container(
                      width: width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                },
                                icon: const Icon(Icons.close)),
                          ),
                          SizedBox(height: 16),
                          CustomTextField(
                              hintText: kAddDescription,
                              controller: descriptionController),
                          const SizedBox(
                            height: 16,
                          ),
                          CustomTextField(
                              hintText: kProvinceName,
                              controller: provinceNameController),
                          const SizedBox(
                            height: 16,
                          ),
                          CustomTextField(
                              hintText: kWardNumber,
                              inputType: TextInputType.number,
                              controller: wardController),
                          const SizedBox(
                            height: 16,
                          ),
                          GestureDetector(
                            onTap: () {
                              showColorPicker(ctx, selectedColor, (color) {
                                updateState(() {
                                  selectedColor = color;
                                });
                              });
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  color: selectedColor,
                                ),
                                const SizedBox(width: 16),
                                Text(kSelectColor),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          CustomButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                onTap(
                                    descriptionController.text.trim(),
                                    provinceNameController.text.trim(),
                                    wardController.text.trim(),
                                    selectedColor);
                                setState(() {
                                  _isDialogOpen = false;
                                });
                              },
                              text: kAdd),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  showColorPicker(
      BuildContext ctx, Color color, Function(Color) onColorSelected) {
    showDialog(
      context: ctx,
      builder: (context) => AlertDialog(
        title: const Text(kPickAColor),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: color,
            onColorChanged: (updatedColor) {
              color = updatedColor;
            },
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onColorSelected(color);
            },
            child: const Text(kSelect),
          ),
        ],
      ),
    );
  }
}
