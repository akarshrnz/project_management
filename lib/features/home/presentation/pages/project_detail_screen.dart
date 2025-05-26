import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:project_management/core/constants/Image_contants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:project_management/features/home/presentation/pages/widgets/video_player_widget.dart';
import '../../domain/entites/project_entity.dart';
import '../bloc/home_bloc.dart';

class ProjectDetailScreen extends StatelessWidget {
  final ProjectEntity project;

  const ProjectDetailScreen({super.key, required this.project});

  void _launchMapRoute() async {
    const origin = '12.9716,77.5946';
    const destination = '13.0827,80.2707';
    final url =
        'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&travelmode=driving';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch map route';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.cyanAccent),
        title: Text(
          project.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.1,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.cyanAccent,
        onPressed: _launchMapRoute,
        tooltip: "Open route in Google Maps",
        child: Image.asset(ImageContsnats.googleMap, height: 28, width: 28),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageCarousel(context, project),
            20.verticalSpace,
            Text(
              project.description,
              style: TextStyle(color: Colors.grey[300], fontSize: 16.sp),
            ),
            24.verticalSpace,
            _buildSectionTitle("Videos"),
            12.verticalSpace,
            _buildVideoList(project, context),
            24.verticalSpace,
            _buildSectionTitle("Progress - Pie Chart"),
            20.verticalSpace,
            _buildPieChart(),
            32.verticalSpace,
            _buildSectionTitle("Progress - Bar Chart"),
            24.verticalSpace,
            _buildBarChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.cyanAccent,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildImageCarousel(BuildContext context, ProjectEntity project) {
    if (project.imageUrls.isEmpty) {
      return const Text("No images available.", style: TextStyle(color: Colors.white70));
    }

    return CarouselSlider.builder(
      itemCount: project.imageUrls.length,
      itemBuilder: (context, index, _) {
        final imageUrl = project.imageUrls[index];
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14.r),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () => context.read<HomeBloc>().add(
                      DeleteProjectImageEvent(project.id, imageUrl),
                    ),
                child: const CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: Icon(Icons.close, color: Colors.redAccent),
                ),
              ),
            ),
          ],
        );
      },
      options: CarouselOptions(
        height: 200.h,
        enlargeCenterPage: true,
        autoPlay: true,
        viewportFraction: 0.85,
      ),
    );
  }

  Widget _buildVideoList(ProjectEntity project, BuildContext context) {
    if (project.videoUrls.isEmpty) {
      return const Text("No videos available.", style: TextStyle(color: Colors.white70));
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: project.videoUrls.length,
      separatorBuilder: (_, __) => 16.verticalSpace,
      itemBuilder: (_, index) {
        final videoUrl = project.videoUrls[index];
        return VideoPlayerWidget(
          url: videoUrl,
          onDelete: () {
            context.read<HomeBloc>().add(
              DeleteProjectVideoEvent(project.id, videoUrl),
            );
          },
        );
      },
    );
  }

  Widget _buildPieChart() {
    return SizedBox(
      height: 180,
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 35,
          sectionsSpace: 3,
          sections: [
            PieChartSectionData(
              value: 40,
              title: 'Dev',
              color: Colors.blueAccent,
              radius: 60,
              titleStyle: const TextStyle(color: Colors.white),
            ),
            PieChartSectionData(
              value: 30,
              title: 'Design',
              color: Colors.orangeAccent,
              radius: 60,
              titleStyle: const TextStyle(color: Colors.white),
            ),
            PieChartSectionData(
              value: 20,
              title: 'QA',
              color: Colors.greenAccent,
              radius: 60,
              titleStyle: const TextStyle(color: Colors.white),
            ),
            PieChartSectionData(
              value: 10,
              title: 'PM',
              color: Colors.purpleAccent,
              radius: 60,
              titleStyle: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, _) => Text(
                  "W${value.toInt() + 1}",
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ),
            ),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barGroups: List.generate(
            5,
            (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: (index + 1) * 10.0,
                  color: Colors.cyanAccent,
                  width: 20,
                  borderRadius: BorderRadius.circular(4),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: 60,
                    color: Colors.white10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
