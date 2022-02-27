FROM mcr.microsoft.com/dotnet/aspnet:5.0-focal AS base
WORKDIR /app
EXPOSE 8080

ENV ASPNETCORE_URLS=http://*:8080

FROM mcr.microsoft.com/dotnet/sdk:5.0-focal AS build
WORKDIR /src
COPY ["Cloud.csproj", "./"]
RUN dotnet restore "Cloud.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "Cloud.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Cloud.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Cloud.dll"]
