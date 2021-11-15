import 'dart:io';
import 'package:bloc/bloc.dart';

part 'image_picker_state.dart';

class ImagePickerCubit extends Cubit<ImagePickerState> {
  ImagePickerCubit() : super(ImagePickerState(File('')));

  setImage(File value) => emit(ImagePickerState(value));
}
