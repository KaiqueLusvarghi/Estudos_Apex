# 🚀 Salesforce Apex Development — Case Studies

> Implementações práticas de soluções no ecossistema Salesforce, focadas em automação de processos de negócio utilizando **Apex Triggers**, **Domain Design Patterns** (Service/Handler) e **Unit Testing**.

---

## 📌 Visão Geral dos Projetos

Os exercícios simulam cenários reais de uma consultoria , abordando desde cálculos complexos de precificação até automações de tarefas baseadas em mudanças de estado.

---

### 1. Gestão de Oportunidades & Descontos

**Objetivo:** Automatizar o cálculo do preço final de uma oportunidade com base em percentuais de desconto.

**Regras de Negócio:**
- ✅ Validação de teto de desconto (máximo 50%)
- 🔄 Cálculo automático no evento `Before Insert/Update`
- 📋 Criação de tarefas de follow-up automatizadas quando o estágio é alterado para `Closed Won`

**Tecnologias:** Apex Classes, Triggers, DML, Mapas de ID (Old/New Map comparison)

---

### 2. Sistema de Intenção de Venda (Leads — Frota)

**Objetivo:** Gerenciar a venda de frotas de veículos através do objeto Lead.

**Regras de Negócio:**
- 💰 Cálculo de Valor Total (Quantidade × Preço Unitário)
- 🚫 Bloqueio de vendas acima de 20 veículos (exige aprovação do Diretor)
- 🤝 Automação de Pós-Venda: Geração de `Task` utilizando `WhoId` no momento da conversão do Lead

**Desafio Técnico:** Implementação realizada via Developer Console para fortalecer o domínio da sintaxe e lógica de execução.

---

## 🛠️ Arquitetura de Software

Para garantir a escalabilidade e manutenção do código, foi adotado o padrão de **separação de responsabilidades**:

```
📁 Triggers     →  Apenas roteiam os eventos (Logicless Triggers)
📁 Handlers     →  Gerenciam o contexto da trigger e executam filtros de negócio
                   (ex: comparação de status antigo vs. novo)
📁 Services     →  Contêm a lógica pesada e cálculos, permitindo reutilização
                   em outras partes do sistema (como em LWCs ou APIs)
```

---

## 🧪 Qualidade e Testes (Unit Testing)

O projeto prioriza a robustez através de **Classes de Teste Apex**, cobrindo 100% dos cenários:

| Tipo de Teste | Descrição |
|---|---|
| ✅ **Positivos** | Validação de fluxos com dados válidos |
| ❌ **Negativos** | Garantia de que as exceções (`IllegalArgumentException`) são lançadas corretamente ao violar regras de negócio |
| 🔗 **Integração** | Verificação da persistência de dados e criação de registros relacionados (Tasks) |

---

## 👨‍💻 Tecnologias Utilizadas

- ![Apex](https://img.shields.io/badge/Salesforce-Apex-00A1E0?style=flat&logo=salesforce&logoColor=white) 
- 🔍 **SOQL** — Salesforce Object Query Language
- 🛢️ **DML** — Data Manipulation Language
- 💻 **Salesforce CLI & VS Code**
- 🖥️ **Salesforce Developer Console**

---

## 📬 Contato

**Kaique** — Salesforce Developer Trainee

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Kaique-0A66C2?style=flat&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/kaique-lusvarghi-salesforce)
