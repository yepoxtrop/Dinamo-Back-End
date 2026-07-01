create or alter procedure usp_insertar_logs

as
begin
	begin try
		insert into [dbo].[logs](
			[log_titulo],
		)
	end try
	begin catch
	
	end catch
end 