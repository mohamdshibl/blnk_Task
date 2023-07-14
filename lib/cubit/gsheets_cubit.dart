import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'gsheets_states.dart';

class GoogleSheetsCubit extends Cubit<GoogleSheetStates> {

  GoogleSheetsCubit() : super(InitialState());

  static GoogleSheetsCubit get(context) => BlocProvider.of(context);





}