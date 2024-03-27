import 'package:admin_menu_mobile/common/widget/common_text_field.dart';
import 'package:admin_menu_mobile/core/utils/contants.dart';
import 'package:admin_menu_mobile/core/utils/extensions.dart';
import 'package:admin_menu_mobile/core/utils/util.dart';
import 'package:admin_menu_mobile/features/category/data/model/category_model.dart';
import 'package:flutter/material.dart';

class CreateOrUpdateCategory extends StatefulWidget {
  const CreateOrUpdateCategory(
      {super.key, required this.categoryModel, required this.mode});
  final CategoryModel categoryModel;
  final Mode mode;

  @override
  State<CreateOrUpdateCategory> createState() => _CreateOrUpdateCategoryState();
}

class _CreateOrUpdateCategoryState extends State<CreateOrUpdateCategory> {
  late Mode _mode;
  late CategoryModel _categoryModel;

  var _imageFile;
  String _image = '';
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _desCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _mode = widget.mode;
    _initData();
    super.initState();
  }

  void _initData() {
    if (_mode == Mode.update) {
      _categoryModel = widget.categoryModel;
      _nameCtrl.text = _categoryModel.name ?? '';
      _desCtrl.text = _categoryModel.description ?? '';
      _image = _categoryModel.image ?? noImage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppbar(),
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildImageCatagory(),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                _buildTitle('Tên danh mục (*):'),
                                const SizedBox(height: 8),
                                _buildNameCatagory(),
                                const SizedBox(height: 16),
                                _buildTitle('Mô tả:'),
                                const SizedBox(height: 8),
                                _buildDescriptionCatagory()
                              ]),
                          const SizedBox(height: 32),
                          _buildButton(),
                          const SizedBox(height: 8),
                          Text('(*) không được để trống',
                              style: context.textStyleSmall!.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: context.colorScheme.error))
                        ])))));
  }

  _buildTitle(String title) => Text(title,
      style: context.titleStyleMedium!.copyWith(fontWeight: FontWeight.bold));

  _buildNameCatagory() => CommonTextField(
        hintText: 'Tên danh mục',
        controller: _nameCtrl,
        prefixIcon: const Icon(Icons.abc),
        validator: (value) =>
            value == null || value.isEmpty ? 'Tên danh mục không hợp lệ' : null,
        onChanged: (p0) {},
      );

  _buildDescriptionCatagory() => CommonTextField(
        controller: _desCtrl,
        hintText: 'Mô tả',
        prefixIcon: const Icon(Icons.description),
        onChanged: (p0) {},
      );

  _buildButton() => FilledButton(
      onPressed: _mode == Mode.create
          ? () => _handelCreateCategory()
          : () => _handelUpdateCategory(),
      child: Text(_mode == Mode.create ? 'Thêm danh mục' : 'Chỉnh sửa'));

  _handelCreateCategory() {
    final invalid = _formKey.currentState?.validate() ?? false;
    if (invalid) {
    } else {}
  }

  _handelUpdateCategory() {
    final invalid = _formKey.currentState?.validate() ?? false;
    if (invalid) {
    } else {}
  }

  _buildImageCatagory() {
    return Stack(children: [
      _imageFile == null
          ? Container(
              height: context.sizeDevice.width * 0.3,
              width: context.sizeDevice.width * 0.3,
              clipBehavior: Clip.hardEdge,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(color: context.colorScheme.primary),
                  shape: BoxShape.circle),
              child: Image.network(_image.isEmpty ? noImage : _image))
          : Container(
              height: context.sizeDevice.width * 0.3,
              width: context.sizeDevice.width * 0.3,
              clipBehavior: Clip.hardEdge,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(color: context.colorScheme.primary),
                  shape: BoxShape.circle),
              child: Image.file(_imageFile!)),
      Positioned(
          top: context.sizeDevice.width * 0.3 - 25,
          left: (context.sizeDevice.width * 0.3 - 20) / 2,
          child: GestureDetector(
              onTap: () async {
                await pickImage().then((value) {
                  setState(() {
                    _imageFile = value;
                  });
                });
              },
              child: const Icon(Icons.camera_alt_rounded, color: Colors.white)))
    ]);
  }

  _buildAppbar() => AppBar(
      centerTitle: true,
      title: Text(_mode == Mode.create ? 'Thêm danh mục' : "Chỉnh sửa danh mục",
          style: context.titleStyleMedium));
}
