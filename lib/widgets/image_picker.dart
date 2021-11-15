import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:road_to_the_throne/bloc/cubits/image_picker/image_picker_cubit.dart';
import 'package:road_to_the_throne/helpers/image_picker.dart';
import 'package:road_to_the_throne/widgets/profile_pic_placeholder.dart';
import 'image_picker_item.dart';

class ImagePicker extends StatefulWidget {
  const ImagePicker({Key? key}) : super(key: key);

  @override
  _ImagePickerState createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {
  late ImagePickerCubit imagePickerCubit;

  @override
  void initState() {
    super.initState();
    imagePickerCubit = BlocProvider.of<ImagePickerCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          await showModalBottomSheet(
              backgroundColor: Colors.white,
              context: context,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              builder: (c) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ImagePickerItem(
                          text: 'Camera',
                          icon: Icons.camera_alt,
                          function: () async {
                            imagePickerCubit.setImage(
                                await ImagePickerHelper.pickImage(
                                    ImageSource.camera, context));
                            Navigator.of(c).pop();
                          },
                        ),
                        ImagePickerItem(
                            text: 'Gallery',
                            icon: Icons.image,
                            function: () async {
                              imagePickerCubit.setImage(
                                  await ImagePickerHelper.pickImage(
                                      ImageSource.gallery, context));
                              Navigator.of(c).pop();
                            }),
                      ],
                    ),
                  ));
        },
        child: Consumer<ImagePickerCubit>(
          builder: (context, provider, _) => provider.state.image.path != ''
              ? CircleAvatar(
                  backgroundImage: FileImage(provider.state.image), radius: 75)
              : const ProfilePicPlaceHolder(),
        ));
  }
}
