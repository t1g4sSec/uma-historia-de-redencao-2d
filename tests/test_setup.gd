extends GutTest

# Teste de fumaça do setup — confirma que o GUT está rodando dentro do projeto.
func test_gut_is_wired_up():
	assert_eq(1 + 1, 2, "sanity check")
