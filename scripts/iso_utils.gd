class_name IsoUtils
extends RefCounted

## Convenção de tile isométrico do projeto — todo TileSet/TileMapLayer
## isométrico do jogo (mapa estratégico ou cena jogável de província/
## cidade/aldeia) deve usar este tamanho, pra manter grid e câmera
## consistentes entre cenas diferentes.
##
## Personagens seguem essa mesma referência (ver .claude/agents/
## character-prompter.md): base ~1 tile de largura (TILE_SIZE.x),
## altura em pé entre 1,5x e 2x TILE_SIZE.y.
const TILE_SIZE := Vector2i(128, 64)

## Posição de mundo (relativa ao próprio TileMapLayer) do centro de uma célula.
static func map_to_world(layer: TileMapLayer, coord: Vector2i) -> Vector2:
	return layer.map_to_local(coord)

## Célula correspondente a uma posição de mundo (relativa ao próprio TileMapLayer).
static func world_to_map(layer: TileMapLayer, world_pos: Vector2) -> Vector2i:
	return layer.local_to_map(world_pos)
