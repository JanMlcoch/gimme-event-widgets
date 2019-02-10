///This library handles task queuing and prioritizing.
library sidos.scheduler;

import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:collection';
import '../sidos_entities/library.dart';
import 'package:logging/logging.dart' as log;

part 'scheduler.dart';
part 'task.dart';
part 'task_manufacturer.dart';
part 'task_data.dart';
part 'task_subtypes/additional_info.dart';
part 'task_subtypes/basic_subtypes.dart';
part 'task_subtypes/hard_cache.dart';
part 'task_subtypes/processing_request.dart';