{application, 'intcode', [
	{description, "New project"},
	{vsn, "0.1.0"},
	{modules, ['intcode','intcode_app','intcode_handler','intcode_sup']},
	{registered, [intcode_sup]},
	{applications, [kernel,stdlib,cowboy]},
	{mod, {intcode_app, []}},
	{env, []}
]}.