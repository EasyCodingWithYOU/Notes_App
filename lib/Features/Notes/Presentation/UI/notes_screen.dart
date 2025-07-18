import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notes/Core/Routes/route_names.dart';
import 'package:notes/Features/Auth/Presentation/Auth_Bloc/auth_bloc.dart';
import 'package:notes/Features/Auth/Presentation/Auth_Bloc/auth_event.dart';
import 'package:notes/Features/Notes/Domain/Entity/notes_entity.dart';
import 'package:notes/Features/Notes/Presentation/bloc/notes_bloc.dart';
import 'package:notes/Features/Notes/Presentation/bloc/notes_event.dart';
import 'package:notes/Features/Notes/Presentation/bloc/notes_state.dart';

class NotesScreen extends StatefulWidget {
  final String uid;

  const NotesScreen({super.key, required this.uid});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  void initState() {
    super.initState();
    // Load notes when screen initializes
    context.read<NoteBloc>().add(LoadNotes(widget.uid));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'My Notes',
          style: TextStyle(
            color: const Color(0xFF2D3748),
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(SignOut());
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteNames.splash,
                  (_) => false,
                );
              },
              icon: Icon(Icons.logout),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if (state is NoteLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
              ),
            );
          } else if (state is NoteError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.w,
                    color: const Color(0xFFE53E3E),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Error: ${state.message}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xFFE53E3E),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<NoteBloc>().add(LoadNotes(widget.uid));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF667EEA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text('Retry', style: TextStyle(fontSize: 14.sp)),
                  ),
                ],
              ),
            );
          } else if (state is NoteLoaded) {
            return _buildNotesView(state.notes);
          } else {
            return _buildEmptyState();
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddNoteDialog(context),
        backgroundColor: const Color(0xFF667EEA),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add Note',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildNotesView(List<NoteEntity> notes) {
    if (notes.isEmpty) {
      return _buildEmptyState();
    }

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive grid based on screen width
          int crossAxisCount = 1;
          if (constraints.maxWidth > 600) {
            crossAxisCount = 2; // Tablet view
          }
          if (constraints.maxWidth > 900) {
            crossAxisCount = 3; // Large tablet/desktop
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: 0.85,
            ),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              return _buildNoteCard(notes[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildNoteCard(NoteEntity note) {
    // Random gradient colors for each card
    final gradients = [
      [const Color(0xFF667EEA), const Color(0xFF764BA2)],
      [const Color(0xFFf093fb), const Color(0xFFf5576c)],
      [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
      [const Color(0xFF43e97b), const Color(0xFF38f9d7)],
      [const Color(0xFFfa709a), const Color(0xFFfee140)],
      [const Color(0xFFa8edea), const Color(0xFFfed6e3)],
      [const Color(0xFFffecd2), const Color(0xFFfcb69f)],
      [const Color(0xFFd299c2), const Color(0xFFfef9d7)],
    ];

    final gradientIndex = (note.id?.hashCode ?? 0) % gradients.length;
    final selectedGradient = gradients[gradientIndex];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: selectedGradient,
        ),
        boxShadow: [
          BoxShadow(
            color: selectedGradient[0].withOpacity(0.3),
            blurRadius: 15.r,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22.r),
        ),
        child: Stack(
          children: [
            // Subtle gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22.r),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    selectedGradient[0].withOpacity(0.05),
                    selectedGradient[1].withOpacity(0.02),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with gradient accent
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: selectedGradient
                                  .map((c) => c.withOpacity(0.1))
                                  .toList(),
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            note.title ?? 'Untitled',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2D3748),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8.r,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              _showEditNoteDialog(context, note);
                            } else if (value == 'delete') {
                              _showDeleteConfirmation(context, note);
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit_outlined,
                                    color: selectedGradient[0],
                                  ),
                                  SizedBox(width: 8.w),
                                  const Text('Edit'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.delete_outline,
                                    color: Color(0xFFE53E3E),
                                  ),
                                  SizedBox(width: 8.w),
                                  const Text('Delete'),
                                ],
                              ),
                            ),
                          ],
                          child: Padding(
                            padding: EdgeInsets.all(8.w),
                            child: Icon(
                              Icons.more_vert_rounded,
                              color: const Color(0xFF718096),
                              size: 20.w,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Content with better styling
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: selectedGradient[0].withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              note.message ?? '',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF4A5568),
                                height: 1.5,
                                letterSpacing: 0.2,
                              ),
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Footer with enhanced design
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: selectedGradient
                            .map((c) => c.withOpacity(0.08))
                            .toList(),
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: selectedGradient[0].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Icon(
                            Icons.schedule_rounded,
                            size: 12.w,
                            color: selectedGradient[0],
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Just now', // You can add your date formatting here
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: selectedGradient[0],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Subtle corner decoration
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: selectedGradient
                        .map((c) => c.withOpacity(0.1))
                        .toList(),
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(22.r),
                    bottomLeft: Radius.circular(20.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_add_outlined,
            size: 80.w,
            color: const Color(0xFFCBD5E0),
          ),
          SizedBox(height: 16.h),
          Text(
            'No notes yet',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF4A5568),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Tap the + button to create your first note',
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF718096)),
          ),
        ],
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        elevation: 16,
        child: Container(
          width: 1.sw > 600 ? 400.w : 0.9.sw,
          constraints: BoxConstraints(
            maxHeight: 0.8.sh,
            maxWidth: 1.sw > 600 ? 400.w : 0.9.sw,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF7FAFC), Color(0xFFEDF2F7)],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFF667EEA).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.note_add_outlined,
                          color: const Color(0xFF667EEA),
                          size: 24.w,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          'Add New Note',
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2D3748),
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close_rounded,
                          size: 20.w,
                          color: const Color(0xFF718096),
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey.shade100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  // Title Field
                  Text(
                    'Title',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF4A5568),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: titleController,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: const Color(0xFF2D3748),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter note title...',
                        hintStyle: TextStyle(
                          color: const Color(0xFF718096),
                          fontSize: 16.sp,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: const Color(0xFF667EEA),
                            width: 2.w,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Content Field
                  Text(
                    'Content',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF4A5568),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: contentController,
                      maxLines: 4,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: const Color(0xFF2D3748),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Write your note content here...',
                        hintStyle: TextStyle(
                          color: const Color(0xFF718096),
                          fontSize: 16.sp,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: const Color(0xFF667EEA),
                            width: 2.w,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              side: BorderSide(
                                color: const Color(0xFFE2E8F0),
                                width: 1.w,
                              ),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: const Color(0xFF718096),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (titleController.text.isNotEmpty ||
                                contentController.text.isNotEmpty) {
                              final note = NoteEntity(
                                id: DateTime.now().millisecondsSinceEpoch
                                    .toString(),
                                title: titleController.text,
                                message: contentController.text,
                                uid: widget.uid,
                              );
                              context.read<NoteBloc>().add(AddNewNote(note));
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF667EEA),
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            'Add Note',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditNoteDialog(BuildContext context, NoteEntity note) {
    final titleController = TextEditingController(text: note.title);
    final contentController = TextEditingController(text: note.message);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        elevation: 16,
        child: Container(
          width: 1.sw > 600 ? 400.w : 0.9.sw,
          constraints: BoxConstraints(
            maxHeight: 0.8.sh,
            maxWidth: 1.sw > 600 ? 400.w : 0.9.sw,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF7FAFC), Color(0xFFEDF2F7)],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFF667EEA).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.edit_outlined,
                          color: const Color(0xFF667EEA),
                          size: 24.w,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          'Edit Note',
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2D3748),
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close_rounded,
                          size: 20.w,
                          color: const Color(0xFF718096),
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey.shade100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  // Title Field
                  Text(
                    'Title',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF4A5568),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: titleController,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: const Color(0xFF2D3748),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter note title...',
                        hintStyle: TextStyle(
                          color: const Color(0xFF718096),
                          fontSize: 16.sp,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: const Color(0xFF667EEA),
                            width: 2.w,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Content Field
                  Text(
                    'Content',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF4A5568),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: contentController,
                      maxLines: 4,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: const Color(0xFF2D3748),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Write your note content here...',
                        hintStyle: TextStyle(
                          color: const Color(0xFF718096),
                          fontSize: 16.sp,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: const Color(0xFF667EEA),
                            width: 2.w,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              side: BorderSide(
                                color: const Color(0xFFE2E8F0),
                                width: 1.w,
                              ),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: const Color(0xFF718096),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final updatedNote = NoteEntity(
                              id: note.id,
                              title: titleController.text,
                              message: contentController.text,
                              uid: note.uid,
                            );
                            context.read<NoteBloc>().add(
                              UpdateNoteEvent(updatedNote),
                            );
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF667EEA),
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            'Update Note',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, NoteEntity note) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        elevation: 16,
        child: Container(
          width: 1.sw > 600 ? 350.w : 0.85.sw,
          constraints: BoxConstraints(maxWidth: 1.sw > 600 ? 350.w : 0.85.sw),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFF5F5), Color(0xFFFED7D7)],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon and Header
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53E3E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: const Color(0xFFE53E3E),
                    size: 32.w,
                  ),
                ),

                SizedBox(height: 20.h),

                Text(
                  'Delete Note',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3748),
                  ),
                ),

                SizedBox(height: 12.h),

                Text(
                  'Are you sure you want to delete this note? This action cannot be undone.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xFF4A5568),
                    height: 1.5,
                  ),
                ),

                SizedBox(height: 32.h),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            side: BorderSide(
                              color: const Color(0xFFE2E8F0),
                              width: 1.w,
                            ),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: const Color(0xFF718096),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<NoteBloc>().add(
                            DeleteNoteEvent(note.id!),
                          );
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE53E3E),
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
