---
name: run-tests
description: Roda a suíte de testes GUT do projeto Godot e reporta falhas, delegando investigação/correção ao agent godot-qa quando necessário. Use quando o usuário pedir para rodar os testes, verificar se o jogo ainda funciona, ou depois de mudanças relevantes de código.
---

## Fluxo

1. Rode: `godot --headless --path . -s addons/gut/gut_cmdln.gd -gdir=res://tests -gexit`
   - Se der erro de "class_names have not been imported", rode `godot --headless --import` uma vez e tente de novo (acontece depois de adicionar scripts novos com `class_name`).
2. Se tudo passar: reporte o resumo (quantos testes, tempo) e pare — não precisa delegar nada.
3. Se algo falhar: delegue ao agent `godot-qa` a investigação e correção de cada falha, uma de cada vez, revisando a causa raiz (não um contorno).
4. Depois de qualquer correção, rode a suíte de novo para confirmar que passou e que nada mais quebrou.
