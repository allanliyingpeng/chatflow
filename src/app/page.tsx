import { Header } from '@/components/header'
import { WorkflowCard } from '@/components/workflow-card'
import { workflows } from '@/lib/workflows'

export default function Home() {
  return (
    <div className="min-h-screen bg-background">
      <Header />

      <main className="container max-w-7xl mx-auto py-8 px-4">
        <div className="mb-12 text-center">
          <h2 className="text-4xl font-bold tracking-tight mb-6">探索 Dify 工作流</h2>
          <p className="text-muted-foreground text-xl max-w-3xl mx-auto leading-relaxed">
            体验各种智能工作流，从AI助手到内容创作，从数据分析到代码审查，
            选择合适的工具来提升您的工作效率。
          </p>
        </div>

        <div className="flex justify-center">
          <div className="w-full max-w-6xl">
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
              {workflows.map((workflow) => (
                <WorkflowCard key={workflow.id} workflow={workflow} />
              ))}
            </div>
          </div>
        </div>

        {workflows.length === 0 && (
          <div className="text-center py-12">
            <p className="text-muted-foreground text-lg">暂无可用的工作流</p>
          </div>
        )}
      </main>

      <footer className="border-t py-8 mt-16">
        <div className="container text-center text-sm text-muted-foreground">
          <p>Powered by Dify | Built with Next.js & Tailwind CSS</p>
        </div>
      </footer>
    </div>
  )
}