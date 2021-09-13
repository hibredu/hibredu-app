export default function getSuggestionName(column: string) {
    const columnLowerCase = column.toLowerCase()
    if(columnLowerCase.includes("nome"))
    {
        return "Nome"
    }
    else if(columnLowerCase.includes("atividade"))
    {
        return "Atividade"
    }
    else if(columnLowerCase.includes("data") || columnLowerCase.includes("hora")) 
    {
        return "Controle de horário"
    }
    else 
    {
        return ""
    }
}