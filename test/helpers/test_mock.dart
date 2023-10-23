import 'package:flutter/cupertino.dart';
import 'package:mockito/annotations.dart';
import 'package:tddboilerplate/features/features.dart';

@GenerateMocks([
  AuthRepository,
  AuthRemoteDatasource,
  UsersRepository,
  UsersRemoteDatasource,
  UsersLocalDatasource,
  UserBoxMixin,
])
@GenerateNiceMocks([MockSpec<BuildContext>()])
void main() {}
