CREATE PROCEDURE  [dabarc].[sp_TPT_UpdateListOfActive_Reg] 
      @plantillad_id int,
      @active int     
AS
BEGIN
      DECLARE @register_date datetime
      SET @register_date = GETDATE()
      UPDATE       dabarc.t_PlantillaD
      SET               active = @active           
      WHERE        (plantillad_id = @plantillad_id);
END
