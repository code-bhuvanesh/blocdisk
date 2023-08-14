import 'package:blocdisk/features/home_page/tabs/myfiles.dart';
import 'package:blocdisk/features/home_page/tabs/sharedfiles.dart';
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
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {},
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Bloc Disk",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
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
