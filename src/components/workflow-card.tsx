"use client"

import { useState } from 'react'
import { ExternalLink, MessageSquare, Tag } from 'lucide-react'
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle } from '@/components/ui/dialog'
import { WorkflowConfig } from '@/types/workflow'
import { cn } from '@/lib/utils'

interface WorkflowCardProps {
  workflow: WorkflowConfig
}

export function WorkflowCard({ workflow }: WorkflowCardProps) {
  const [isDialogOpen, setIsDialogOpen] = useState(false)

  const handleOpenWorkflow = () => {
    if (workflow.openMode === 'new_tab') {
      window.open(workflow.difyUrl, '_blank', 'noopener,noreferrer')
    } else {
      setIsDialogOpen(true)
    }
  }

  const getCategoryColor = (category?: string) => {
    const colors = {
      assistant: 'bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-300',
      creative: 'bg-purple-100 text-purple-800 dark:bg-purple-900 dark:text-purple-300',
      analysis: 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-300',
      development: 'bg-orange-100 text-orange-800 dark:bg-orange-900 dark:text-orange-300',
      language: 'bg-pink-100 text-pink-800 dark:bg-pink-900 dark:text-pink-300',
      business: 'bg-indigo-100 text-indigo-800 dark:bg-indigo-900 dark:text-indigo-300',
    }
    return colors[category as keyof typeof colors] || 'bg-gray-100 text-gray-800 dark:bg-gray-900 dark:text-gray-300'
  }

  return (
    <>
      <Card className="group h-full cursor-pointer transition-all duration-200 hover:shadow-lg hover:scale-[1.02]" onClick={handleOpenWorkflow}>
        <CardHeader className="pb-3">
          <div className="flex items-center justify-between">
            <CardTitle className="text-lg font-semibold line-clamp-1">{workflow.title}</CardTitle>
            {workflow.openMode === 'new_tab' ? (
              <ExternalLink className="h-4 w-4 text-muted-foreground group-hover:text-foreground transition-colors" />
            ) : (
              <MessageSquare className="h-4 w-4 text-muted-foreground group-hover:text-foreground transition-colors" />
            )}
          </div>
          {workflow.category && (
            <div className="flex items-center gap-2">
              <span className={cn(
                "inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium",
                getCategoryColor(workflow.category)
              )}>
                {workflow.category}
              </span>
            </div>
          )}
        </CardHeader>

        <CardContent className="pb-3">
          <CardDescription className="text-sm text-muted-foreground line-clamp-3">
            {workflow.description}
          </CardDescription>
        </CardContent>

        {workflow.tags && workflow.tags.length > 0 && (
          <CardFooter className="pt-0">
            <div className="flex items-center gap-1 flex-wrap">
              <Tag className="h-3 w-3 text-muted-foreground" />
              {workflow.tags.slice(0, 3).map((tag, index) => (
                <span
                  key={index}
                  className="inline-flex items-center rounded-md bg-muted px-2 py-1 text-xs font-medium text-muted-foreground"
                >
                  {tag}
                </span>
              ))}
              {workflow.tags.length > 3 && (
                <span className="text-xs text-muted-foreground">+{workflow.tags.length - 3}</span>
              )}
            </div>
          </CardFooter>
        )}
      </Card>

      <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
        <DialogContent className="max-w-4xl h-[80vh] p-0">
          <DialogHeader className="p-6 pb-0">
            <DialogTitle>{workflow.title}</DialogTitle>
            <DialogDescription>{workflow.description}</DialogDescription>
          </DialogHeader>
          <div className="flex-1 p-6 pt-0">
            <div className="w-full h-full rounded-lg border bg-background">
              <iframe
                src={workflow.difyUrl}
                className="w-full h-full rounded-lg"
                style={{ minHeight: '500px' }}
                sandbox="allow-same-origin allow-scripts allow-forms allow-popups allow-top-navigation"
                loading="lazy"
                title={workflow.title}
                referrerPolicy="strict-origin-when-cross-origin"
              />
            </div>
          </div>
        </DialogContent>
      </Dialog>
    </>
  )
}