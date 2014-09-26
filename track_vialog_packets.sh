#
# no meu caso ele é executado pelo cron a cada X horas e só notifica caso haja
# mudança no status de entrega, pode ser melhorado, mas esta funcionando
#!/bin/bash
#
FORM_ACT=".form-response.html"
FORM_OLD=".form-response-bkp.html"
HIST=".form-response-hist.txt"
MAILTOINFORM="mailTosendtrack@mail.net"
PACOTE="$1"


# Importante: efetua a comunicação envio de dados e obtem pagina
curl -s -d cnpj="xxxxxxxxx" http://www.ssw.inf.br/2/resultSSW_dest > ${FORM_ACT}


# Legado
# ---------------
if [ $# -eq 1 ]; then
	identificacao=`cat  ${FORM_ACT} | grep "B2W" | awk '/B2W/ { print $9 } ' | sed 's@[^0-9]@@g'`

	for i in $identificacao
	do
		if [ $i == ${PACOTE} ]; then
			echo -e " \033[44;1;37m PACOTE ENCONTRADO \033[0m \n\n\n\n\n "
			flag=1
		fi
	done

	if [ -z $flag ]; then
		echo -e "\033[41;1;37mNAO ENCONTRADO \033[0m \n\n\n\n\n  "
		echo "Atual Encontrado: $identificacao \n\n "
	fi
fi
# ---------------

# Compara o ultimo download (minutos atrás) com o download feito agora (nessa execução).
# Compara se os dois arquivos obtidos do servidor possuem qualquer diferença
diff ${FORM_ACT} ${FORM_OLD} &> /dev/null
if [ $? -ne 0 ]; then

	# Entra nesse bloco se os arquivos forem diferentes	e analisa o download atual

	# Analisa o HTML e copia conteudo da tag html 'titulo'
	DIFE=`cat ${FORM_ACT} | grep titulo | sed -e 's/titulo>/\n/g' | sed -e 's/<font/\n/g' | sed -n '2p'`
	
	# Envia email com texto parseado do html
	if [[ -n $DIFE ]]; then								# Testa para evitar envio de email em branco
		if [[ `tail -1 ${HIST}` != ${DIFE} ]]; then		# Testa para evitar envio repetido
			echo ${DIFE} | mail -s "Encomenda Status" $MAILTOINFORM
			echo ${DIFE} >> ${HIST}
		fi
	fi

	echo "STATUS: ${DIFE}"
    
	# Substitui o html atual para o antigo
    cp ${FORM_ACT} ${FORM_OLD}
fi
