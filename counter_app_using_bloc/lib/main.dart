import 'package:counter_app_using_bloc/bloc/cubit/counter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<CounterCubit>(
        create: (context) => CounterCubit(),
        child: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            BlocConsumer<CounterCubit, CounterState>(
              listener: (context, state) {
                if (state.wasInc == false) {
                  if (state.counterValue == 0) {
                    // ignore: deprecated_member_use
                    Scaffold.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Reset"),
                      ),
                    );
                  } else {
                    // ignore: deprecated_member_use
                    Scaffold.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Decremented"),
                      ),
                    );
                  }
                } else {
                  // ignore: deprecated_member_use
                  Scaffold.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Incremented"),
                      ),
                    );
                }
              },
              builder: (context, state) {
                return BlocBuilder<CounterCubit, CounterState>(
                  builder: (context, state) {
                    return Text(
                      '${state.counterValue}',
                      style: Theme.of(context).textTheme.headline4,
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              BlocProvider.of<CounterCubit>(context).inc();
            },
            child: const Icon(Icons.add),
            tooltip: "Increment",
          ),
          Container(
            width: 40.0,
          ),
          FloatingActionButton(
            onPressed: () {
              BlocProvider.of<CounterCubit>(context).dec();
            },
            child: const Icon(Icons.remove),
            tooltip: "Decrement",
          ),
          Container(width: 40.0),
          FloatingActionButton(
            onPressed: () {
              BlocProvider.of<CounterCubit>(context).reset();
            },
            child: const Icon(Icons.loop),
            tooltip: "Reset",
          ),
        ],
      ),
    );
  }
}
