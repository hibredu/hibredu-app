export default function cleanDate(date, days) {
    var result = new Date(date.toString());
    result.setDate(result.getDate() + days);
    return result;
}