import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_management/features/home/domain/entites/project_entity.dart';
import 'package:project_management/features/home/presentation/bloc/home_bloc.dart';
import 'package:project_management/features/home/presentation/pages/widgets/add_project_dialog.dart';
import 'package:project_management/features/home/presentation/pages/widgets/project_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ProjectEntity> _allProjects = [];
  List<ProjectEntity> _filteredProjects = [];

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(FetchProjectsEvent());
  }

  void _filterProjects(String query) {
    setState(() {
      _filteredProjects = _allProjects
          .where((project) =>
              project.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _showAddProjectPopup() {
    showDialog(
      context: context,
      builder: (context) => const AddProjectDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Projects",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: Colors.white,
            letterSpacing: 1.1,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showAddProjectPopup,
            icon: const Icon(Icons.add_circle_outline, color: Colors.cyanAccent, size: 28),
            tooltip: 'Add Project',
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF121212),
                borderRadius: BorderRadius.circular(30.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterProjects,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.cyanAccent,
                decoration: InputDecoration(
                  hintText: "Search projects...",
                  hintStyle: TextStyle(color: Colors.cyanAccent.withOpacity(0.6)),
                  prefixIcon: const Icon(Icons.search, color: Colors.cyanAccent),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Expanded(
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.cyanAccent),
                    );
                  } else if (state is HomeLoaded) {
                    _allProjects = state.projects;
                    final displayProjects = _searchController.text.isEmpty
                        ? _allProjects
                        : _filteredProjects;

                    if (displayProjects.isEmpty) {
                      return Center(
                        child: Text(
                          "No projects found.",
                          style: TextStyle(color: Colors.grey[600], fontSize: 16.sp),
                        ),
                      );
                    }

                    return ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: displayProjects.length,
                      separatorBuilder: (_, __) => SizedBox(height: 16.h),
                      itemBuilder: (context, index) {
                        final project = displayProjects[index];
                        return Material(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(16.r),
                          elevation: 4,
                          shadowColor: Colors.cyanAccent.withOpacity(0.5),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16.r),
                            splashColor: Colors.cyanAccent.withOpacity(0.3),
                            onTap: () {
                              // Handle tap if needed
                            },
                            child: ProjectCard(project: project),
                          ),
                        );
                      },
                    );
                  } else if (state is HomeError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: TextStyle(color: Colors.redAccent.shade200, fontSize: 16.sp),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyanAccent,
        onPressed: _showAddProjectPopup,
        child: const Icon(Icons.add, color: Colors.black),
        tooltip: 'Add Project',
        elevation: 6,
      ),
    );
  }
}
