import 'dart:io';
import 'package:admin_menu_mobile/common/dialog/progress_dialog.dart';
import 'package:admin_menu_mobile/features/table/bloc/table_bloc.dart';
import 'package:admin_menu_mobile/features/table/model/table_model.dart';
import 'package:admin_menu_mobile/utils/app_alerts.dart';
import 'package:admin_menu_mobile/utils/utils.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/bloc/generic_bloc_state.dart';
import '../../common/dialog/retry_dialog.dart';
import '../../widgets/widgets.dart';

enum Mode { create, update }

class CreateTable extends StatefulWidget {
  const CreateTable({super.key, required this.mode, this.tableModel});
  final Mode mode;
  final TableModel? tableModel;
  @override
  State<CreateTable> createState() => _CreateTableState();
}

class _CreateTableState extends State<CreateTable> {
  final TextEditingController _nameController = TextEditingController();

  final _seats = ['2', '4', '6', '8', '10', '12', '14', '16', '18', '20'];
  var _seat = '';
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  var _image = '';
  var _loading = false;

  @override
  void initState() {
    initValue();
    super.initState();
  }

  void initValue() {
    if (widget.tableModel != null && widget.mode == Mode.update) {
      _seat = widget.tableModel!.seats.toString();
      _image = widget.tableModel!.image;
      _nameController.text = widget.tableModel!.name;
    }
  }

  Future _uploadPicture() async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child('table/${DateTime.now()}+"1"');
    UploadTask uploadTask = storageReference.putFile(_imageFile!);
    await uploadTask.whenComplete(() async {
      var url = await storageReference.getDownloadURL();
      var imageUrl = url.toString();
      setState(() {
        _image = imageUrl;
      });
    });
  }

  Future pickImage() async {
    final imagePicker = ImagePicker();
    var imagepicked = await imagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);
    if (imagepicked != null) {
      setState(() {
        _imageFile = File(imagepicked.path);
      });
    } else {
      logger.d('No image selected!');
    }
  }

  Widget _buildSeats() {
    return Wrap(
        spacing: 4.0,
        runSpacing: 2.0,
        children: _seats
            .map((e) => SizedBox(
                height: 25,
                child: FilledButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(_seat == e
                            ? context.colorScheme.errorContainer
                            : context.colorScheme.primaryContainer)),
                    onPressed: () {
                      setState(() {
                        _seat = e;
                      });
                    },
                    child: Text(e, style: context.textStyleSmall))))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppbar(context),
        body: SafeArea(
            child: SizedBox(
                height: context.sizeDevice.height * 0.8,
                width: context.sizeDevice.width,
                child: Form(
                    key: _formKey,
                    child: Padding(
                        padding: EdgeInsets.all(defaultPadding),
                        child: SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // _buildAppbar(context),
                                  SizedBox(height: defaultPadding / 2),
                                  _ImageFood(
                                      onTap: () => pickImage(),
                                      imageFile: _imageFile),
                                  SizedBox(height: defaultPadding / 2),
                                  _buildTitle('Tên bàn:'),
                                  SizedBox(height: defaultPadding / 2),
                                  _NameTable(nameController: _nameController),
                                  SizedBox(height: defaultPadding / 2),
                                  _buildTitle('Số ghế:'),
                                  SizedBox(height: defaultPadding / 2),
                                  _buildSeats(),
                                  SizedBox(height: defaultPadding / 2),
                                  _buildButtonCreateTable(),
                                  SizedBox(height: defaultPadding / 2)
                                ]
                                    .animate(interval: 50.ms)
                                    .slideX(
                                        begin: -0.1,
                                        end: 0,
                                        curve: Curves.easeInOutCubic,
                                        duration: 500.ms)
                                    .fadeIn(
                                        curve: Curves.easeInOutCubic,
                                        duration: 500.ms))))))));
  }

  Widget _buildButtonCreateTable() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      _loading
          ? SpinKitCircle(color: context.colorScheme.secondary, size: 30)
          : FilledButton.icon(
              onPressed: () => handleCreateTable(),
              icon: const Icon(Icons.add_box),
              label: _buildTitle('Thêm bàn'))
    ]);
  }

  Future<void> handleCreateTable() async {
    final toast = FToast()..init(context);
    if (_formKey.currentState!.validate()) {
      if (_seat == '' || _imageFile == null) {
        toast.showToast(
            child:
                AppAlerts.errorToast(context, msg: 'Chưa thêm hình hoặc ghế!'));
      } else {
        setState(() {
          _loading = true;
        });
        await _uploadPicture()
            .then((value) => value)
            .catchError((onError) {})
            .then((value) {
          var table = TableModel(
              id: '',
              image: _image,
              name: _nameController.text,
              seats: int.parse(_seat));
          createTable(table);
        }).then((value) {
          setState(() {
            _loading = false;
          });
        });
      }
    }
  }

  void createTable(TableModel tableModel) {
    context.read<TableBloc>().add(TableCreated(tableModel: tableModel));
    showDialog(
        context: context,
        builder: (_) {
          return BlocBuilder<TableBloc, GenericBlocState<TableModel>>(
              builder: (context, state) {
            return switch (state.status) {
              Status.empty => const SizedBox(),
              Status.loading => const SizedBox(),
              Status.failure => RetryDialog(
                  title: state.error ?? "Error",
                  onRetryPressed: () => context
                      .read<TableBloc>()
                      .add(TableCreated(tableModel: tableModel))),
              Status.success => ProgressDialog(
                  descriptrion: "Đã tạo bàn: ${tableModel.name}",
                  onPressed: () {
                    pop(context, 2);
                  },
                  isProgressed: false)
            };
          });
        });
  }

  Widget _buildTitle(String title) {
    return Text(title,
        style: context.textStyleMedium!.copyWith(fontWeight: FontWeight.bold));
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
        centerTitle: true,
        title: Text(widget.mode == Mode.create ? 'Tạo bàn ăn' : 'Cập nhật',
            style:
                context.textStyleLarge!.copyWith(fontWeight: FontWeight.bold)));
  }
}

class _ImageFood extends StatelessWidget {
  final File? imageFile;
  final Function()? onTap;

  const _ImageFood({required this.onTap, required this.imageFile});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: imageFile == null
            ? Container(
                height: 155,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(defaultBorderRadius)),
                child: DottedBorder(
                    dashPattern: const [6, 6],
                    color: context.colorScheme.secondary,
                    strokeWidth: 1,
                    radius: Radius.circular(defaultBorderRadius),
                    borderType: BorderType.RRect,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                  height: 48,
                                  width: 48,
                                  decoration: BoxDecoration(
                                      color: context.colorScheme.primary,
                                      border: Border.all(
                                          color: context.colorScheme.primary,
                                          width: 1),
                                      borderRadius: BorderRadius.circular(
                                          defaultBorderRadius)),
                                  child: Icon(Icons.add,
                                      color: context.colorScheme.secondary))),
                          SizedBox(height: defaultPadding / 2),
                          Text("Hình ảnh món ăn", style: context.textStyleSmall)
                        ])))
            : Container(
                height: 155,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(defaultBorderRadius),
                    image: DecorationImage(
                        image: FileImage(imageFile!), fit: BoxFit.cover))));
  }
}

class _NameTable extends StatelessWidget {
  final TextEditingController nameController;

  const _NameTable({required this.nameController});

  @override
  Widget build(BuildContext context) {
    return CommonTextField(
        prefixIcon: const Icon(Icons.food_bank_rounded),
        hintText: 'Tên bàn ăn',
        controller: nameController,
        validator: (value) {
          if (value == null || value == '') {
            return 'Tên không được để trống';
          } else {
            return null;
          }
        },
        onChanged: (text) {
          nameController.text = text;
        });
  }
}
