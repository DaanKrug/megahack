defmodule ExApp.MessagesUtil do

  alias ExApp.ReturnUtil
  
  def systemMessage(messageCode,parameters \\ []) do
    cond do
      (messageCode == 0) -> ReturnUtil.getOperationError("Erro de operação.")
      (messageCode == 200) -> ReturnUtil.getOperationSuccess(200,"",Enum.at(parameters,0))
      (messageCode == 201) -> ReturnUtil.getOperationSuccess(201,"")
      (messageCode == 204) -> ReturnUtil.getOperationSuccess(204,"")
      (messageCode == 205) -> ReturnUtil.getValidationResult(205,"OK")
      (messageCode == 207) -> ReturnUtil.getOperationSuccess(207,"")
      (messageCode == 208) -> ReturnUtil.getOperationSuccess(208,"")
      (messageCode == 209) -> ReturnUtil.getOperationSuccess(209,Enum.at(parameters,0))
      (messageCode == 210) -> ReturnUtil.getOperationSuccess(210,Enum.at(parameters,0))
      (messageCode == 211) -> ReturnUtil.getOperationSuccess(211,Enum.at(parameters,0))
      (messageCode == 212) -> ReturnUtil.getOperationSuccess(212,Enum.at(parameters,0))
      (messageCode == 403) -> ReturnUtil.getOperationError("Falta de permissão de acesso ao recurso.")
	  (messageCode == 412) -> ReturnUtil.getOperationError("Falha de pré condição.")
	  (messageCode == 413) -> ReturnUtil.getOperationError("[TESTE] Falha de pré condição.")
	  (messageCode == 480) -> ReturnUtil.getValidationResult(480,
	                          """
	                          Preencher corretamente os campos requeridos 
	                          para criar novo(a) <strong>#{Enum.at(parameters,0)}</strong>.
	                          """)
	  (messageCode == 481) -> ReturnUtil.getValidationResult(481,
	                          """
	                          Preencher corretamente os campos requeridos 
	                          para alterar <strong>#{Enum.at(parameters,0)}</strong>.
	                          """)
	  (messageCode == 482) -> ReturnUtil.getValidationResult(482,
	                          "Falha ao criar novo(a) <strong>#{Enum.at(parameters,0)}</strong>.")
	  (messageCode == 483) -> ReturnUtil.getValidationResult(483,
	                          "Falha ao alterar <strong>#{Enum.at(parameters,0)}</strong>.")
      (messageCode == 100000) -> ReturnUtil.getValidationResult(100000,
                                 """
                                 Já existe uma pessoa/usuário com o email: 
                                 <strong>#{Enum.at(parameters,0)}</strong>.
                                 """)
      (messageCode == 100001) -> ReturnUtil.getValidationResult(100001,
                                 """
                                 Mudança de categoria não permitida para a 
                                 <strong>pessoa/usuário</strong> em questão.
                                 """)
      (messageCode == 100003) -> ReturnUtil.getValidationResult(100003,
                                 "<strong>Pessoa/Usuário</strong> em questão não pode ser excluída.")
      (messageCode == 100004) -> ReturnUtil.getValidationResult(100004,
                                 """
                                 Obrigatório informar corretamente os campos <strong>Nome</strong>, 
                                 <strong>E-mail</strong> 
                                 e <strong>Senha</strong>.
                                 """)
      (messageCode == 100005) -> ReturnUtil.getValidationResult(100005,
                                 "Falha ao criar <strong>pessoa/usuário</strong>.")
      (messageCode == 100006) -> ReturnUtil.getValidationResult(100006,
                                 "Falha ao efetuar <strong>registro</strong>.")
      (messageCode == 100007) -> ReturnUtil.getValidationResult(100007,
                                 "Falha ao alterar <strong>pessoa/usuário</strong>.")
      (messageCode == 100008) -> ReturnUtil.getValidationResult(100008,
                                 "Não foi possível ativar <strong>usuário</strong>.")
      (messageCode == 100009) -> ReturnUtil.getValidationResult(100009,"Falha ao ativar <strong>usuário</strong>.")
      (messageCode == 100011) -> ReturnUtil.getValidationResult(100011,"Falha ao recuperar <strong>senha</strong>.")
      (messageCode == 100014) -> ReturnUtil.getValidationResult(100014,
                                 "<strong>E-mail</strong> em processamento, não pode ser alterado.")
      (messageCode == 100015) -> ReturnUtil.getValidationResult(100015,
                                 "<strong>E-mail</strong> em processamento, não pode ser excluído.")
      (messageCode == 100016) -> ReturnUtil.getValidationResult(100016,"Falha ao criar <strong>e-mail</strong>.")
      (messageCode == 100017) -> ReturnUtil.getValidationResult(100017,"Falha ao alterar <strong>e-mail</strong>.")
      (messageCode == 100018) -> ReturnUtil.getValidationResult(100018,
                                 """
                                 <strong>E-mail</strong> já enviado para 1 ou mais destinatários, 
                                 não pode ser alterado.
                                 """)
      (messageCode == 100019) -> ReturnUtil.getValidationResult(100019,
                                 """
                                 O e-mail: <strong>#{Enum.at(parameters,0)}</strong>, 
                                 não se encaixa nas regras para novo registro.
                                 """)
      (messageCode == 100023) -> ReturnUtil.getValidationResult(100023,
                                 """
                                 Obrigatório informar corretamente os campos <strong>Provedor</strong>, 
                                 <strong>Identificação</strong>,
                                 <strong>Login/Endereço de E-mail</strong>, 
                                 <strong>Senha</strong> e <strong>Replay-To</strong>.
                                 """)
      (messageCode == 100024) -> ReturnUtil.getValidationResult(100024,
                                 "Falha ao criar <strong>configuração envio e-mail</strong>.")
      (messageCode == 100025) -> ReturnUtil.getValidationResult(100025,
                                 "Falha ao alterar <strong>configuração envio e-mail</strong>.")
      (messageCode == 100026) -> ReturnUtil.getValidationResult(100026,
                                 """
                                 Obrigatório informar corretamente os campos <strong>Identificação</strong> 
                                 e <strong>Link</strong>.
                                 """)
      (messageCode == 100027) -> ReturnUtil.getValidationResult(100027,"Falha ao criar <strong>arquivo</strong>.")
      (messageCode == 100028) -> ReturnUtil.getValidationResult(100028,"Falha ao alterar <strong>arquivo</strong>.")
      (messageCode == 100029) -> ReturnUtil.getValidationResult(100029,"Falha ao criar <strong>imagem</strong>.")
      (messageCode == 100030) -> ReturnUtil.getValidationResult(100030,"Falha ao alterar <strong>imagem</strong>.")
      (messageCode == 100031) -> ReturnUtil.getValidationResult(100031,
                                 "Obrigatório informar campo <strong>Identificação</strong>.")
      (messageCode == 100032) -> ReturnUtil.getValidationResult(100032,"Falha ao criar <strong>menu</strong>.")
      (messageCode == 100033) -> ReturnUtil.getValidationResult(100033,"Falha ao alterar <strong>menu</strong>.")
      (messageCode == 100034) -> ReturnUtil.getValidationResult(100034,"<strong>Menu</strong> informado não existe.")
      (messageCode == 100035) -> ReturnUtil.getValidationResult(100035,
                                 """
                                 Obrigatório informar corretamente os campos <strong>Identificação</strong> 
                                 e <strong>Conteúdo</strong>.
                                 """)
      (messageCode == 100036) -> ReturnUtil.getValidationResult(100036,"Falha ao criar <strong>item menu</strong>.")
      (messageCode == 100037) -> ReturnUtil.getValidationResult(100037,"Falha ao alterar <strong>item menu</strong>.")
      (messageCode == 100038) -> ReturnUtil.getValidationResult(100038,
                                 "<strong>Item menu</strong> informado não existe.")
      (messageCode == 100039) -> ReturnUtil.getValidationResult(100039,
                                 "Falha ao criar <strong>arquivo item menu</strong>.")
      (messageCode == 100041) -> ReturnUtil.getValidationResult(100041,
                                 "<strong>Arquivo</strong> informado não existe.")
      (messageCode == 100042) -> ReturnUtil.getValidationResult(100042,
                                 "<strong>Arquivo</strong> informado já está adicionado ao Item Menu.")
      (messageCode == 100047) -> ReturnUtil.getValidationResult(100047,"Falha ao criar <strong>módulo</strong>.")
      (messageCode == 100048) -> ReturnUtil.getValidationResult(100048,"Falha ao alterar <strong>módulo</strong>.")
      (messageCode == 100049) -> ReturnUtil.getValidationResult(100049,
                                 "<strong>Módulo</strong> informado já está adicionado na aplicação.")
      (messageCode == 100054) -> ReturnUtil.getValidationResult(100054,
                                 """
                                 Obrigatório informar corretamente os campos <strong>Identificação</strong>, 
                                 <strong>Descrição</strong> e <strong>Url Site</strong>.
                                 """)
      (messageCode == 100055) -> ReturnUtil.getValidationResult(100055,
                                 """
                                 Já existe outra <strong>configuração</strong> ativa para a aplicação. 
                                 Não é permitido ter mais de uma configuração ativa ao mesmo tempo.
                                 """)
      (messageCode == 100056) -> ReturnUtil.getValidationResult(100056,
                                 "Falha ao criar <strong>configuração</strong>.")
      (messageCode == 100057) -> ReturnUtil.getValidationResult(100057,
                                 "Falha ao alterar <strong>configuração</strong>.")
      (messageCode == 100065) -> ReturnUtil.getValidationResult(100065,
                                 "<strong>Pessoa/Usuário</strong> informada não existe.")
      (messageCode == 100075) -> ReturnUtil.getValidationResult(100075,
                                 """
                                 <strong>Pessoa/Usuário</strong> em questão não pode ser excluída, 
                                 pois tem <strong>pessoa/usuário</strong> em sua responsabilidade.
                                 """)
      (messageCode == 100078) -> ReturnUtil.getValidationResult(100078,
                                 """
                                 Mudança de categoria não permitida para a <strong>pessoa/usuário</strong> em questão,
                                 pois tem <strong>pessoa/usuário</strong> em sua responsabilidade.
                                 """)
      (messageCode == 100082) -> ReturnUtil.getValidationResult(100082,
                                 """
                                 Mudança de categoria não permitida para a <strong>pessoa/usuário</strong> em questão,
                                 pois tem <strong>e-mail</strong> em sua responsabilidade.
                                 """)                           
      (messageCode == 100083) -> ReturnUtil.getValidationResult(100083,
                                 """
                                 <strong>Pessoa/Usuário</strong> em questão não pode ser excluída,
                                 pois tem <strong>e-mail</strong> em sua responsabilidade.
                                 """)  
      (messageCode == 100090) -> ReturnUtil.getValidationResult(100090,
                                 """
                                 Mudança de categoria não permitida para a <strong>pessoa/usuário</strong> em questão,
                                 pois tem <strong>módulo</strong> em sua responsabilidade.
                                 """)                           
      (messageCode == 100091) -> ReturnUtil.getValidationResult(100091,
                                 """
                                 <strong>Pessoa/Usuário</strong> em questão não pode ser excluída,
                                 pois tem <strong>módulo</strong> em sua responsabilidade.
                                 """)   
      (messageCode == 100096) -> ReturnUtil.getValidationResult(100096,
                                 """
                                 Mudança de categoria não permitida para a <strong>pessoa/usuário</strong> em questão,
                                 pois tem <strong>configuração e-mail</strong> em sua responsabilidade.
                                 """)                           
      (messageCode == 100097) -> ReturnUtil.getValidationResult(100097,
                                 """
                                 <strong>Pessoa/Usuário</strong> em questão não pode ser excluída,
                                 pois tem <strong>configuração e-mail</strong> em sua responsabilidade.
                                 """) 
      (messageCode == 100098) -> ReturnUtil.getValidationResult(100098,
                                 """
                                 Mudança de categoria não permitida para a <strong>pessoa/usuário</strong> em questão,
                                 pois tem <strong>imagem</strong> em sua responsabilidade.
                                 """)                           
      (messageCode == 100099) -> ReturnUtil.getValidationResult(100099,
                                 """
                                 <strong>Pessoa/Usuário</strong> em questão não pode ser excluída,
                                 pois tem <strong>imagem</strong> em sua responsabilidade.
                                 """) 
      (messageCode == 100100) -> ReturnUtil.getValidationResult(100100,
                                 """
                                 Mudança de categoria não permitida para a <strong>pessoa/usuário</strong> em questão,
                                 pois tem <strong>arquivo</strong> em sua responsabilidade.
                                 """)                           
      (messageCode == 100101) -> ReturnUtil.getValidationResult(100101,
                                 """
                                 <strong>Pessoa/Usuário</strong> em questão não pode ser excluída,
                                 pois tem <strong>arquivo</strong> em sua responsabilidade.
                                 """) 
      (messageCode == 100106) -> ReturnUtil.getValidationResult(100106,
                                 """
                                 Mudança de categoria não permitida para a <strong>pessoa/usuário</strong> em questão,
                                 pois tem <strong>configuração aplicação</strong> em sua responsabilidade.
                                 """)                           
      (messageCode == 100107) -> ReturnUtil.getValidationResult(100107,
                                 """
                                 <strong>Pessoa/Usuário</strong> em questão não pode ser excluída,
                                 pois tem <strong>configuração aplicação</strong> em sua responsabilidade.
                                 """)  
      (messageCode == 100112) -> ReturnUtil.getValidationResult(100112,
                                 """
                                 <strong>Menu</strong> em questão não pode ser excluído,
                                 pois tem <strong>item menu</strong> vinculado.
                                 """)
      (messageCode == 100113) -> ReturnUtil.getValidationResult(100113,
                                 """
                                 <strong>Item Menu</strong> em questão não pode ser excluído,
                                 pois tem <strong>arquivo item menu</strong> vinculado.
                                 """)
      (messageCode == 100116) -> ReturnUtil.getValidationResult(100116,
                                 """
                                 <strong>Pessoa/Usuário</strong> em questão não pode ser excluída,
                                 pois tem <strong>configuração email</strong> vinculada.
                                 """)  
      (messageCode == 100127) -> ReturnUtil.getValidationResult(100127,
                                 """
                                 <strong>Pessoa/Usuário</strong> em questão não pode ser excluída,
                                 pois tem <strong>configuração AWS S3</strong> em sua responsabilidade.
                                 """) 
      (messageCode == 100128) -> ReturnUtil.getValidationResult(100128,
                                 """
                                 Mudança de categoria não permitida para a <strong>pessoa/usuário</strong> em questão,
                                 pois tem <strong>configuração AWS S3</strong> em sua responsabilidade.
                                 """)  
      (messageCode == 100129) -> ReturnUtil.getValidationResult(100129,
                                 """
                                 Obrigatório informar corretamente os campos <strong>Bucket Name</strong>, 
                                 <strong>Bucket URL</strong>, <strong>Region</strong>, <strong>Version</strong>, 
                                 <strong>Key</strong> e <strong>Secret</strong>.
                                 """)
      (messageCode == 100130) -> ReturnUtil.getValidationResult(100130,
                                 "Falha ao criar <strong>configuração AWS S3</strong>.")
      (messageCode == 100131) -> ReturnUtil.getValidationResult(100131,
                                 "Falha ao alterar <strong>configuração AWS S3</strong>.")
      (messageCode == 100132) -> ReturnUtil.getValidationResult(100132,
                                 """
                                 Já existe outra <strong>configuração AWS S3</strong> ativa para a aplicação. 
                                 Não é permitido ter mais de uma configuração AWS S3 ativa ao mesmo tempo.
                                 """)
      (messageCode == 100133) -> ReturnUtil.getValidationResult(100133,
                                 """
                                 Erro ao ativar <strong>configuração AWS S3</strong> para a aplicação.
                                 """) 
      (messageCode == 100147) -> ReturnUtil.getValidationResult(100147,
                                 """
                                 Admin Master não pode criar usuário com permissão 
                                 <strong>Comunicação/Acesso Externa</strong>.
                                 """)
      (messageCode == 100148) -> ReturnUtil.getValidationResult(100148,
                                 "Falha ao criar <strong>Cliente</strong>.")
      (messageCode == 100149) -> ReturnUtil.getValidationResult(100149,
                                 "Falha ao alterar <strong>Cliente</strong>.")
      (messageCode == 100150) -> ReturnUtil.getValidationResult(100150,
                                 "<strong>Cliente</strong> informado não existe.")
      (messageCode == 100151) -> ReturnUtil.getValidationResult(100151,
                                 "Falha ao criar <strong>Solicitação de Nova Ligação</strong>.")
      (messageCode == 100152) -> ReturnUtil.getValidationResult(100152,
                                 "Falha ao alterar <strong>Solicitação de Nova Ligação</strong>.")
      (messageCode == 100153) -> ReturnUtil.getValidationResult(100153,
                                 """
                                 <strong>Cliente</strong> não pode ser excluído pois tem 
                                 <strong>solicitação de nova ligação</strong> vinculada.
                                 """)
      (messageCode == 100154) -> ReturnUtil.getValidationResult(100154,
                                 "Falha ao criar <strong>Unidade Consumidora</strong>.")
      (messageCode == 100155) -> ReturnUtil.getValidationResult(100155,
                                 "Falha ao alterar <strong>Unidade Consumidora</strong>.")
      (messageCode == 100156) -> ReturnUtil.getValidationResult(100156,
                                 "<strong>Unidade Consumidora</strong> não encontrada para o CPF.")
      (messageCode == 100157) -> ReturnUtil.getValidationResult(100157,
                                 "<strong>Unidade Consumidora</strong> não encontrada para o CNPJ.")
      (messageCode == 100158) -> ReturnUtil.getValidationResult(100158,
                                 """
                                 Falta de Energia registrada com sucesso para a 
                                 Unidade Consumidora <strong>Enum.at(parameters,0)</strong>.
                                 <br/>
                                 Seu protocolo de atendimento é <strong>Enum.at(parameters,1)</strong>
                                 """)
      (messageCode == 100159) -> ReturnUtil.getValidationResult(100159,
                                 "<strong>Unidade Consumidora</strong> informada não foi encontrada.")
      true -> systemMessage(0)
    end
  end

end













