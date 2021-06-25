({
    handleClick : function(component, event, helper) {
        var uNmae = componente.get("v.nome");
        alert("Bem Vindo, "+ uNmae);
        component.set("v.nome","");
    }
})