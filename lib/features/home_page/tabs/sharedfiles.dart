import 'package:blocdisk/features/home_page/widgets/shared_file_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/shared_file_model.dart';
import '../../../utils/solconnect.dart';
import '../bloc/home_bloc.dart';

class SharedFilesTab extends StatefulWidget {
  const SharedFilesTab({super.key});

  @override
  State<SharedFilesTab> createState() => _SharedFilesTabState();
}

class _SharedFilesTabState extends State<SharedFilesTab> {
  @override
  void initState() {
    context.read<HomeBloc>().add(GetSharedFilesEvent());
    super.initState();
  }

  List<Widget> fileWidgets = [];
  List<SharedFileModel> filesList = [];
  var solConnect = SolConnect();
  bool isLoading = true;

  final ScrollController _scrollController = ScrollController();

  void getFiles() async {
    setState(() {
      // filesList.addAll(newFiles);
      fileWidgets = filesList
          .map(
            (e) => BlocProvider(
              create: (context) => HomeBloc(),
              child: SharedFileWidget(
                file: e,
                isUploading: false,
                parentContext: context,
              ),
            ),
          )
          .toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is SharedFilesRecived) {
          filesList = state.newFiles;
          getFiles();
        }
      },
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<HomeBloc>().add(GetMyFilesEvent());
        },
        child: (filesList.isNotEmpty && !isLoading)
            ? RefreshIndicator(
                onRefresh: () async {
                  context.read<HomeBloc>().add(GetMyFilesEvent());
                },
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: filesList.length,
                  itemBuilder: (context, index) =>
                      fileWidgets[filesList.length - (index + 1)],
                ),
              )
            : filesList.isEmpty && !isLoading
                ? const Center(
                    child: Text("no files uploaded"),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
      ),
    );
  }
}
