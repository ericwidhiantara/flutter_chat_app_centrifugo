import 'package:flutter/cupertino.dart';
import 'package:mockito/annotations.dart';
import 'package:tdd_boilerplate/features/features.dart';

@GenerateMocks([
  AuthRepository,
  AuthRemoteDatasource,
  UsersRepository,
  UsersRemoteDatasource,
])
@GenerateNiceMocks([MockSpec<BuildContext>()])
void main() {}
