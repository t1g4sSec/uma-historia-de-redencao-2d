---
name: review-art
description: Revisa artes 2D isométricas pendentes (pasta assets/art/inbox) contra o design doc, usando o agent art-reviewer, e organiza o resultado (aprovadas vão para assets/art/approved, reprovadas ficam com anotação do motivo). Use quando o usuário pedir para revisar arte nova, ou disser que adicionou layouts/sprites para avaliação.
---

## Fluxo

1. Liste as imagens novas em `assets/art/inbox/` (crie a pasta, com `assets/art/approved/`, se ainda não existirem).
2. Para cada imagem (ou lote relacionado, ex: um spritesheet de personagem), delegue a revisão ao agent `art-reviewer` — ele lê a imagem e o design doc e devolve veredito + motivo.
3. Apresente o resumo dos vereditos ao usuário antes de mover qualquer arquivo.
4. Após confirmação do usuário:
   - **Aprovado** → mover para `assets/art/approved/`.
   - **Precisa de ajuste** → manter em `inbox/`, anotar o motivo (ex: num arquivo `<nome>.review.md` ao lado da imagem, ou na resposta ao usuário — perguntar qual preferem se ainda não tiver convenção).
   - **Reprovado** → manter em `inbox/` com o motivo; não excluir a imagem sem o usuário pedir.

Nunca mova ou aprove uma imagem automaticamente sem o usuário ter visto o veredito — a revisão final é sempre humana, o agent só instrui a decisão.
