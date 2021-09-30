import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:source_gen/source_gen.dart';

import 'src/builder/aggregating_builder.dart';
import 'src/builder/graph_builder.dart';
import 'src/builder/json_builder.dart';
import 'src/generator/gate_inject_generator.dart';
import 'src/generator/gate_provider_generator.dart';
import 'src/generator/gate_schema_generator.dart';

Builder classSchemaBuilder(BuilderOptions options) => JsonBuilder(GateSchemaGenerator());

Builder gateBuilder(BuilderOptions options) => GateGraphBuilder(GateCodeGenerator());

Builder gateInjectBuilder(BuilderOptions options) => SharedPartBuilder([GateInjectGenerator()], 'gate_inject');
