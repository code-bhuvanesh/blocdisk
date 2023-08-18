import 'package:blocdisk/features/auth/bloc/auth_bloc.dart';
import 'package:blocdisk/features/home_page/tabs/myfiles.dart';
import 'package:blocdisk/features/home_page/tabs/sharedfiles.dart';
import 'package:blocdisk/features/login_page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/my_file_model.dart';
import '../../utils/solconnect.dart';
import 'bloc/home_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const routename = "/homepage";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<HomePage> {
  List<Widget> fileWidgets = [];
  List<MyFileModel> filesList = [];
  var solConnect = SolConnect();

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    askPermission();

    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  Future<void> askPermission() async {
    try {
      if (await Permission.storage.request().isGranted) {}
      if (await Permission.manageExternalStorage.request().isGranted) {}
    } on Exception catch (e) {
      print("error: $e");
    }
  }

  late TabController _tabController;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {},
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Logedout) {
              Navigator.of(context).popAndPushNamed(LoginPage.routename);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Bloc Disk",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontFamily: 'Valorent',
            ),
          ),
          leading: Container(
              child: Image.asset('assets/icons/logo.png', fit: BoxFit.contain)),
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(LogoutEvent());
                      },
                      child: Text("logout")),
                )
              ],
            )
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const <Widget>[
              Tab(
                child: Text("MyFiles"),
              ),
              Tab(
                child: Text("Shared"),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            MyFilesTab(),
            SharedFilesTab(),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
