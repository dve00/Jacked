import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jacked/src/db/models/exercise_entry.dart';
import 'package:jacked/src/db/models/exercise_set.dart';
import 'package:jacked/src/db/models/workout.dart';
import 'package:jacked/src/db/repositories/repositories.dart';
import 'package:jacked/src/db/seeds.dart';
import 'package:jacked/src/widgets/pages/diary_page/workout_hydrator.dart';
import 'package:jacked/src/widgets/shared/build_context.dart';
import 'package:jacked/src/widgets/shared/widgets/draggable_header_sheet.dart';

class DiaryPage extends StatelessWidget {
  final Repositories repos;

  const DiaryPage({
    super.key,
    required this.repos,
  });

  Future<List<Workout>> listWorkouts() async {
    return repos.workoutRepo.list(orderBy: 'startTime desc');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: listWorkouts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center();
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final workouts = snapshot.requireData;
        return ListView.builder(
          cacheExtent: 100 * MediaQuery.of(context).size.height,
          itemBuilder: (context, index) {
            final workout = workouts[index];
            return DiaryEntry(
              repos: repos,
              workout: workout,
            );
          },
          itemCount: workouts.length,
        );
      },
    );
  }
}

String getPreviewSet(List<ExerciseSet>? sets) {
  if (sets == null || sets.isEmpty) return '';
  return '${sets[0].weight ?? -1}kg x ${sets[0].reps ?? -1}';
}

class ExercisePreview extends Equatable {
  final String key;
  final String displaySet;

  const ExercisePreview({
    required this.key,
    required this.displaySet,
  });

  @override
  List<Object?> get props => [key, displaySet];
}

List<ExercisePreview> getExercisePreviews(
  List<ExerciseEntry>? entries,
) {
  final res = <ExercisePreview>[];
  if (entries == null) return res;
  for (final entry in entries) {
    assert(entry.exercise != null, 'exercise should always be populated here');

    final displaySet = getPreviewSet(entry.sets);
    res.add(
      ExercisePreview(
        key: entry.exercise?.key ?? '',
        displaySet: displaySet,
      ),
    );
  }
  return res;
}

class DiaryEntry extends StatelessWidget {
  final Repositories repos;
  final Workout workout;

  const DiaryEntry({
    super.key,
    required this.repos,
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    final duration = workout.endTime?.difference(workout.startTime);
    final workoutHydrator = WorkoutHydrator(
      repos: repos,
      workout: workout,
    );

    return FutureBuilder(
      future: workoutHydrator.hydrateWorkout(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center();
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final populatedWorkout = snapshot.requireData;
        if (populatedWorkout == null) return const SizedBox.shrink();
        return GestureDetector(
          key: const Key('diary_entry'),
          onTap: () {
            final controller = DraggableScrollableController();
            showGeneralDialog(
              context: context,
              transitionDuration: const Duration(milliseconds: 200),
              pageBuilder: (context, _, _) {
                controller.addListener(() {
                  if (controller.size < 0.15) {
                    Navigator.of(context).maybePop();
                  }
                });
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    await controller.animateTo(
                      0.0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                    );
                  },
                  child: Stack(
                    children: [
                      // the sheet must ignore taps on the barrier
                      GestureDetector(
                        onTap: () {}, // absorb
                        child: DraggableHeaderSheet(
                          sheetMinSnap: 0.1,
                          sheetMaxSnap: 1,
                          controller: controller,
                          headerBody: const SizedBox.shrink(),
                          body: Material(
                            child: DiaryEntryDetails(workout: populatedWorkout),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Card.outlined(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.title,
                    style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (workout.description != null)
                    Text(
                      workout.description!,
                      style: context.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                    ),
                  Text(DateFormat('EEEE, d. MMMM').format(workout.startTime)),
                  if (duration != null) Text('${duration.inHours}h ${duration.inMinutes}m'),
                  ...getExercisePreviews(
                    populatedWorkout.exerciseEntries,
                  ).map((ep) {
                    final translation = context.l10n.getExerciseTranslation(ep.key);
                    final displaySet = ep.displaySet.isNotEmpty
                        ? ep.displaySet
                        : context.l10n.pages_diary_noSets;
                    return Text('${translation.name} $displaySet');
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

List<TableRow> getSetRows(List<ExerciseSet>? sets, List<ExerciseSet>? previousSets, String locale) {
  final res = <TableRow>[];
  if (sets == null || sets.isEmpty) return res;

  final formatter = NumberFormat.decimalPattern(locale)
    ..minimumFractionDigits = 0
    ..maximumFractionDigits = 2;

  const spacerRow = TableRow(
    children: [
      SizedBox(height: 10),
      SizedBox(height: 10),
      SizedBox(height: 10),
      SizedBox(height: 10),
      SizedBox(height: 10),
    ],
  );
  for (var i = 0; i < sets.length; i++) {
    ExerciseSet? previousSet;
    if (previousSets != null) {
      if (i + 1 < previousSets.length) {
        previousSet = previousSets[i];
      }
    }
    res.add(
      TableRow(
        children: [
          Card.filled(
            child: Center(child: Text('${i + 1}')),
          ),
          Center(
            child: Text(
              previousSet != null ? '${previousSet.weight}kg x ${previousSet.reps}' : '-',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
            child: TextFormField(
              controller: TextEditingController(text: formatter.format(sets[i].weight ?? 0)),
              textAlign: TextAlign.center,
              decoration: InputDecoration.collapsed(
                hintText: '',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              enabled: false,
              readOnly: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
            child: TextFormField(
              controller: TextEditingController(text: formatter.format(sets[i].reps ?? 0)),
              textAlign: TextAlign.center,
              decoration: InputDecoration.collapsed(
                hintText: '',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              enabled: false,
              readOnly: true,
            ),
          ),
          const Icon(Icons.check_circle_outline),
        ],
      ),
    );
    if (i + 1 < sets.length) res.add(spacerRow);
  }
  return res;
}

List<ExerciseEntryForm> getExerciseForms(List<ExerciseEntry>? entries) {
  final res = <ExerciseEntryForm>[];
  if (entries == null) return res;

  for (final entry in entries) {
    res.add(ExerciseEntryForm(entry: entry));
  }

  return res;
}

class DiaryEntryDetails extends StatelessWidget {
  final Workout workout;

  const DiaryEntryDetails({
    super.key,
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    final exerciseForms = getExerciseForms(workout.exerciseEntries);
    return ListView.builder(
      itemCount: exerciseForms.length + 1,
      itemBuilder: (context, idx) {
        if (idx == 0) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              workout.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
        return exerciseForms[idx - 1];
      },
    );
  }
}

class ExerciseEntryForm extends StatelessWidget {
  const ExerciseEntryForm({
    super.key,
    required this.entry,
  });

  final ExerciseEntry entry;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                context.l10n.getExerciseTranslation(entry.exercise?.key).name,
                style:
                    Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
            if (entry.notes != null)
              TextFormField(
                key: const Key('exercise-notes-field'),
                controller: TextEditingController(text: entry.notes),
                decoration: InputDecoration(
                  hintText: '',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                enabled: false,
                readOnly: true,
              ),
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const <int, TableColumnWidth>{
                0: FractionColumnWidth(0.1),
                1: FractionColumnWidth(0.3),
                2: FractionColumnWidth(0.25),
                3: FractionColumnWidth(0.25),
                4: FractionColumnWidth(0.1),
              },
              children: [
                TableRow(
                  children: [
                    Center(
                      child: Text(
                        context.l10n.pages_diary_set,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Text(
                        context.l10n.pages_diary_previous,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Text(
                        context.l10n.pages_diary_weight,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Text(
                        context.l10n.pages_diary_reps,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Icon(
                      Icons.check_circle_outline,
                    ),
                  ],
                ),
                const TableRow(
                  children: [
                    SizedBox(height: 10),
                    SizedBox(height: 10),
                    SizedBox(height: 10),
                    SizedBox(height: 10),
                    SizedBox(height: 10),
                  ],
                ),
                ...getSetRows(
                  entry.sets,
                  entry.previousSets,
                  Localizations.localeOf(context).toString(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
