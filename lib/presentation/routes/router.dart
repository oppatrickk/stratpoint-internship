import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:stratpoint_internship/domain/notes/note.dart';
import 'package:stratpoint_internship/presentation/notes/note_form/note_form_page.dart';
import 'package:stratpoint_internship/presentation/notes/notes_overview/notes_overview_page.dart';
import 'package:stratpoint_internship/presentation/sign_in/sign_in_page.dart';
import 'package:stratpoint_internship/presentation/splash/splash_page.dart';

part 'router.gr.dart';

@MaterialAutoRouter(replaceInRouteName: 'Page', routes: <AutoRoute>[
  AutoRoute(
    page: SplashPage,
    initial: true,
  ),
  AutoRoute(
    page: SignInPage,
  ),
  AutoRoute(
    page: NotesOverviewPage,
  ),
  AutoRoute(
    page: NoteFormPage,
    fullscreenDialog: true,
  ),
])
class AppRouter extends _$AppRouter {}
