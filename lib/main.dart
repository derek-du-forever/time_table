import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '课程表',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Comic Sans MS',
      ),
      home: CourseSchedulePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Course {
  final String name;
  final String dayOfWeek;
  final String timeRange;
  final bool isOnline;
  final String? classroom;

  Course({
    required this.name,
    required this.dayOfWeek,
    required this.timeRange,
    required this.isOnline,
    this.classroom,
  });
}

class CourseSchedulePage extends StatefulWidget {
  const CourseSchedulePage({super.key});

  @override
  _CourseSchedulePageState createState() => _CourseSchedulePageState();
}

class _CourseSchedulePageState extends State<CourseSchedulePage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool showOnlyToday = true; // 默认只显示今天的课程

  // 课程数据
  List<List<Course>> items = [
    // 周一
    [
      Course(
        name: "Software Security",
        dayOfWeek: "周一",
        timeRange: "12:00 PM - 01:50 PM",
        isOnline: true,
      ),
    ],
    // 周二
    [
      Course(
        name: "Cloud Computing for Software Development",
        dayOfWeek: "周二",
        timeRange: "12:00 PM - 01:50 PM",
        isOnline: true,
      ),
    ],
    // 周三
    [
      Course(
        name: "Software Testing and Deployment",
        dayOfWeek: "周三",
        timeRange: "08:00 AM - 09:50 AM",
        isOnline: true,
      ),
      Course(
        name: "Emerging Trends in Software Development",
        dayOfWeek: "周三",
        timeRange: "10:00 AM - 11:50 AM",
        isOnline: true,
      ),
      Course(
        name: ":Capstone Project",
        dayOfWeek: "周三",
        timeRange: "03:00 PM - 05:50 PM",
        isOnline: false,
        classroom: 'Stan Grad Centre | Room MD215',
      ),
    ],
    // 周四
    [
      Course(
        name: "Software Security",
        dayOfWeek: "周四",
        timeRange: "10:00 AM - 12:50 PM",
        isOnline: false,
        classroom: "Aldred Centre | Room CB019",
      ),
      Course(
        name: "Emerging Trends in Software Development",
        dayOfWeek: "周四",
        timeRange: "02:00 PM - 03:50 PM",
        isOnline: false,
        classroom: 'Senator Burns Building | Room NJ109',
      ),
    ],
    // 周五
    [
      Course(
        name: "Software Testing and Deployment",
        dayOfWeek: "周五",
        timeRange: "11:00 AM - 12:50 PM",
        isOnline: false,
        classroom: "Stan Grad Centre | Room MB203",
      ),
      Course(
        name: "Cloud Computing for Software Development",
        dayOfWeek: "周五",
        timeRange: "02:00 PM - 04:50 PM",
        isOnline: false,
        classroom: 'Stan Grad Centre | Room MC306',
      ),
    ],
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // 获取当前是周几 (1=周一, 2=周二, ..., 5=周五)
  int getCurrentDay() {
    int today = DateTime.now().weekday;
    return today <= 5 ? today : 0; // 周末返回0，表示不高亮任何一天
  }

  // 获取今天的课程
  List<List<Course>> _getTodayCourses() {
    int currentDay = getCurrentDay();
    if (currentDay > 0 && currentDay <= 5) {
      List<Course> todayCourses = items[currentDay - 1];
      return todayCourses.isEmpty ? [] : [todayCourses];
    }
    return [];
  }

  // 获取今天是周几的索引
  int _getTodayIndex() {
    int currentDay = getCurrentDay();
    return currentDay > 0 ? currentDay - 1 : 0;
  }

  // 获取卡片颜色
  List<Color> getCardGradient(int dayIndex) {
    int currentDay = getCurrentDay();
    if (dayIndex + 1 == currentDay) {
      // 当天高亮
      return [Color(0xFFFF6B9D), Color(0xFFFF8E8E)];
    } else {
      // 其他天
      List<List<Color>> gradients = [
        [Color(0xFF74B9FF), Color(0xFF81ECEC)], // 周一 - 蓝色
        [Color(0xFFA29BFE), Color(0xFFFD79A8)], // 周二 - 紫色
        [Color(0xFF6C5CE7), Color(0xFFA29BFE)], // 周三 - 深紫
        [Color(0xFF00CEC9), Color(0xFF55EFC4)], // 周四 - 青色
        [Color(0xFFFFD93D), Color(0xFF6BCF7F)], // 周五 - 黄绿
      ];
      return gradients[dayIndex % gradients.length];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF), Color(0xFFDEE2E6)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 标题栏
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.school, size: 32, color: Color(0xFF6C5CE7)),
                    SizedBox(width: 12),
                    Text(
                      "课程表",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3436),
                        shadows: [
                          Shadow(
                            offset: Offset(2, 2),
                            blurRadius: 4,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    // 切换按钮
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showOnlyToday = !showOnlyToday;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: showOnlyToday
                                ? [Color(0xFFFF6B9D), Color(0xFFFF8E8E)]
                                : [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: showOnlyToday
                                  ? Color(0xFFFF6B9D).withValues(alpha: 0.4)
                                  : Color(0xFF6C5CE7).withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              showOnlyToday ? Icons.today : Icons.view_week,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: 6),
                            Text(
                              showOnlyToday ? "今天" : "全部",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 课程卡片列表
              Expanded(
                child: AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: showOnlyToday
                            ? _getTodayCourses().length
                            : items.length,
                        itemBuilder: (context, index) {
                          if (showOnlyToday) {
                            List<List<Course>> todayCourses =
                                _getTodayCourses();
                            if (todayCourses.isEmpty) {
                              return _buildNoCourseCard();
                            }
                            return _buildDayCard(
                              _getTodayIndex(),
                              todayCourses[0],
                            );
                          } else {
                            return _buildDayCard(index, items[index]);
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayCard(int dayIndex, List<Course> courses) {
    if (courses.isEmpty) return SizedBox.shrink();

    String dayName = courses[0].dayOfWeek;
    List<Color> gradientColors = getCardGradient(dayIndex);
    bool isToday = dayIndex + 1 == getCurrentDay();

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: isToday ? 12 : 6,
        shadowColor: isToday
            ? Colors.pink.withValues(alpha: 0.5)
            : Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: isToday
              ? BorderSide(color: Color(0xFFFF6B9D), width: 2)
              : BorderSide.none,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 星期标题
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 18,
                            color: Color(0xFF6C5CE7),
                          ),
                          SizedBox(width: 8),
                          Text(
                            dayName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3436),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isToday) ...[
                      SizedBox(width: 12),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, size: 14, color: Colors.amber),
                            SizedBox(width: 4),
                            Text(
                              "今天",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF6B9D),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 16),

                // 课程列表
                ...courses.map((course) => _buildCourseItem(course)).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoCourseCard() {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(40),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.grey[100]!, Colors.grey[200]!],
            ),
          ),
          child: Column(
            children: [
              Icon(Icons.weekend, size: 48, color: Colors.grey[400]),
              SizedBox(height: 16),
              Text(
                "今天没有课程",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 8),
              Text(
                "享受轻松的一天吧！",
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseItem(Course course) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 课程名称和类型图标
          Row(
            children: [
              Icon(
                course.isOnline ? Icons.laptop_mac : Icons.domain,
                color: course.isOnline ? Color(0xFF00CEC9) : Color(0xFFE17055),
                size: 20,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  course.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3436),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: course.isOnline
                      ? Color(0xFF00CEC9).withValues(alpha: 0.2)
                      : Color(0xFF6C5CE7).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  course.isOnline ? "线上" : "线下",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: course.isOnline
                        ? Color(0xFF00CEC9)
                        : Color(0xFF6C5CE7),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),

          // 时间信息
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Color(0xFF636E72)),
              SizedBox(width: 12),
              Text(
                course.timeRange,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF636E72),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // 教室信息（仅线下课程显示）
          if (!course.isOnline && course.classroom != null) ...[
            SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.room, size: 16, color: Color(0xFF636E72)),
                SizedBox(width: 12),
                Text(
                  course.classroom!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF636E72),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ] else if (course.isOnline && course.classroom != null) ...[
            SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.room, size: 16, color: Color(0xFF636E72)),
                SizedBox(width: 12),
                GestureDetector(
                  onTap: () async {
                    if (!await launchUrl(
                      Uri.parse(course.classroom!),
                      mode: LaunchMode.externalApplication, // 推荐
                      webOnlyWindowName: '_blank', // Web 上新开标签页
                    )) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('无法打开链接')));
                    }
                  },
                  child: Text(
                    '进入会议室',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 14,
                      color: Color(0xFF636E72),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
