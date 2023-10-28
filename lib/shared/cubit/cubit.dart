import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

import '../network/local/cache_helper.dart';


class AppCubit extends Cubit<AppStates>
{
  AppCubit() :super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);


}