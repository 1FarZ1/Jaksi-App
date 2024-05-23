import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sample_app/consts/app_colors.dart';

import '../../../utils/validators.dart';
import 'custom_button.dart';
import 'custom_category_drop_down.dart';
import 'custom_text_form_field.dart';
import 'image_picker_grid.dart';

class AddProductView extends HookConsumerWidget {
  const AddProductView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final images = useState<List<XFile>>([]);

    Future<void> pickImage() async {
      if (images.value.length >= 4) return;

      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        images.value = [...images.value, pickedFile];
      }
    }

    void removeImage(int index) {
      images.value = List.from(images.value)..removeAt(index);
    }

    final formKey = useMemoized(() => GlobalKey<FormState>());
    final nameController = useTextEditingController();
    final priceController = useTextEditingController();
    final storeNameController = useTextEditingController();
    final category = useState<int>(1);

    submit(){

    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text('إضافة منتجات'),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('صورة المنتج',
                          style: TextStyle(
                              color: AppColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      ImagePickerGrid(
                        images: images.value,
                        removeImage: removeImage,
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                          onPressed: pickImage,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo, color: AppColors.white),
                              SizedBox(width: 8),
                              Text('اضغط لاضافة الصور ',
                                  style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          )),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        labelText: 'اسم المنتج',
                        hintText: 'ادخل اسم المنتج',
                        controller: nameController,
                      ),
                      CustomTextFormField(
                        labelText: 'السعر',
                        hintText: 'ادخل السعر',
                        keyboardType: TextInputType.number,
                        controller: priceController,
                      ),
                      CustomTextFormField(
                        labelText: 'اسم المتجر',
                        hintText: 'ادخل اسم المتجر',
                        controller: storeNameController,
                      ),
                      const SizedBox(height: 16),
                      CustomCategoryDropDown(
                        onChanged: (val) {
                          category.value = val!;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        child: const Text(' إضافة المنتج',
                            style: TextStyle(
                                color: AppColors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {}
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
